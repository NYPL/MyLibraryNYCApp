# frozen_string_literal: true

class User < ActiveRecord::Base
  include Exceptions
  include LogWrapper
  include Oauth
  include MlnException
  include MlnResponse
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, # this handles uniqueness of email automatically
         :timeoutable # adds session["warden.user.user.session"]["last_request_at"] which we use in sessions_controller

  # Makes getters and setters
  attr_accessor :password
  #auto_increment :barcode
  validates :barcode, :uniqueness => true

  # Validation's for email and pin only occurs when a user record is being
  # created on sign up. Does not occur when updating
  # the record.
  validates :first_name, :last_name, :presence => true
  validates_format_of :first_name, :last_name, :with => /\A[^0-9`!@;#$%\^&*+_=\x00-\x19]+\z/
  validates_format_of :alt_email,:with => Devise::email_regexp, :allow_blank => true, :allow_nil => true
  validates :alt_email, uniqueness: true, allow_blank: true, allow_nil: true
  # validates :barcode, numericality: { in: 27777000000001..27777099999999 }
  # validate :validate_password_pattern, on: :create
  # PASSWORD_FORMAT = /\A(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x
  validate :validate_email_pattern, :on => :create

  has_many :holds

  belongs_to :school
  USER_BARCODE_ALLOTTED_RANGE_MINIMUM = 27777000000001
  USER_BARCODE_ALLOTTED_RANGE_MAXIMUM = 27777099999999

  # # Set default password if one is not set
  # before_validation(on: :create) do
  #   self.password ||= User.default_password
  #   self.password_confirmation ||= User.default_password
  # end


  STATUS_LABELS = {'pending' => 'pending', 'complete' => 'complete'}.freeze


  ## NOTE: Validation methods, including this one, are called twice when
  # making new user from the admin interface. While not a behavior we want,
  # it doesn't currently pose a problem.
  def validate_email_pattern
    if (!defined?(email) || email.blank? || !email.index('@'))
      errors.add(:email, ' is required and should end in @schools.nyc.gov or another participating school address')
      return false
    end
    email.downcase.strip

    allowed_email_patterns = AllowedUserEmailMasks.where(active:true).pluck(:email_pattern)

    index = email.index('@')
    if (index && (allowed_email_patterns.include? email[index..]))
      return true
    else
      errors.add(:email, 'should end in @schools.nyc.gov or another participating school address')
      return false
    end
  end

  def barcode_found_in_sierra
    # Getter for flag that reflects whether there's a user or users in Sierra
    # that correspond(s) to this user object in MLN db.
    # NOTE: The barcode_found_in_sierra is not guaranteed to accurately reflect
    # user sync status, until after you've called check_barcode_uniqueness_with_sierra.
    if @barcode_found_in_sierra.blank?
      return false
    end

    return @barcode_found_in_sierra
  end

  # We don't require passwords, so just create a generic one, yay!
  def self.default_password
    "mylibrarynyc"
  end

  def name(full = false)
    handle = self.email.sub /@.*/, ''
    name = self.first_name
    name += " #{self.last_name}" if full && !self.last_name.nil? && !self.last_name.empty?
    name.nil? ? handle : name
  end

  def contact_email
    !self.alt_email.nil? && !self.alt_email.empty? ? self.alt_email : self.email
  end

  # Enable login by either email or alt_email (DOE email and contact email, respectively)
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:email)
      where(conditions).where(["lower(email) = :value OR lower(alt_email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def multiple_barcodes?
    !self.alt_barcodes.nil? && !self.alt_barcodes.empty?
  end

  def send_unsubscribe_notification_email
    UserMailer.unsubscribe(self).deliver
  end

  # If the user's barcode is not yet finalized, then set its status to
  # 'pending' and save.  In the future, there may be other conditions that
  # could set the user to "pending", and we'll be checking for those here, as well.
  def save_as_pending!
    LogWrapper.log('DEBUG', {
       'message' => "Saving as pending #{self.id}",
       'method' => "#{model_name}.save_as_pending!",
       'status' => "before save action"
    })

    # do we need to fill in a provisional barcode?
    unless self.barcode.present?
      # Note: assign_barcode could throw a RangeError.
      # If it does, we want it to propagate up the stack to the calling method.
      self.barcode = self.assign_barcode!
    end

    self.status = STATUS_LABELS['pending']

    self.save!
  end


  # ################ THE BARCODES SECTION! ################
  # Assigns a barcode based on the current range in the MLN db.
  # Does not check the barcode for availability/uniqueness in Sierra.
  # We have an ActiveJob for that.
  def assign_barcode
    LogWrapper.log('DEBUG', {
       'message' => "Begin assigning barcode to #{self.email}",
       'method' => "#{model_name}.assign_barcode",
       'status' => "start"
      })

    # Integer(string) can raise ArgumentError.  we choose not to rescue it, because
    # not having min and max barcode range boundaries set in the application.yml file
    # should prevent the app from working in a visible manner.
    min_barcode = USER_BARCODE_ALLOTTED_RANGE_MINIMUM
    max_barcode = USER_BARCODE_ALLOTTED_RANGE_MAXIMUM

    # if we're being asked to increment our barcode because it's
    # non-unique in Sierra, then do so here
    if self.barcode
      self.assign_attributes({ barcode: self.barcode + Luhn.control_digit(self.barcode) })

      # Did we go over the limit?  No use stepping back, tell the app we'll
      # need to ask Sierra team for a wider barcode range.
      if self.barcode > max_barcode
        LogWrapper.log('ERROR', {
            'method' => "#{model_name}.assign_barcode!",
            'message' => "MLN app has run out of available user barcodes"
        })
        raise RangeError, "MLN app has run out of available user barcodes"
      end

      LogWrapper.log('DEBUG', {
         'message' => "Had a barcode.  Changed it to #{self.barcode}.  Returning from method.",
         'method' => "#{model_name}.assign_barcode!",
         'status' => "end",
         'user' => {email: self.email}
        })
      return self.barcode
    end

    # runs when this is our first time in this method for this user
    # some databases sort nulls to top of order, other databases sort nulls to bottom of order
    last_user_barcode = User.where.not(barcode: nil).where("barcode < #{max_barcode}").order(barcode: :desc).pluck(:barcode).first

    LogWrapper.log('DEBUG', {
       'message' => "Found last_user_barcode: #{last_user_barcode || 'NIL'}.",
       'method' => "#{model_name}.assign_barcode!",
       'status' => "end",
       'user' => {email: self.email}
      })

    # no non-nil barcodes found?  this should never happen, but let's make sure we can handle it
    if last_user_barcode.blank?
      # Check to see if we're in an empty database, or if it's the opposite case:
      # we've run out of allowed barcodes.  Yes, we might have historical user records
      # with barcodes outside of the range, but we can't be making new records there.
      current_top_barcode = User.where.not(barcode: nil).order(barcode: :desc).pluck(:barcode).first
      
      if current_top_barcode.blank?
        # hurrah, we're in a fresh db, let's start our users table off
        last_user_barcode = min_barcode
      else
        # No more barcodes left in the range available to MLN.
        # Throw an Exception-level exception -- we can't operate with
        # no available barcodes, and this exception shouldn't be caught
        LogWrapper.log('ERROR', {
            'method' => "#{model_name}.assign_barcode!",
            'message' => "MLN app has run out of available user barcodes"
        })
        raise RangeError, "MLN app has run out of available user barcodes"
      end
    end

    if (last_user_barcode < min_barcode)
      last_user_barcode = min_barcode
    end

    self.assign_attributes({ barcode: last_user_barcode + 1 })

    LogWrapper.log('DEBUG', {
       'message' => "Barcode has been assigned to #{self.email}",
       'method' => "#{model_name}.assign_barcode!",
       'status' => "end",
       'barcode' => "#{self.barcode}"
      })
    return self.barcode
  end

  def create_patron_delayed_job
    Rails.logger.info "Entering Delay Job For"
    Delayed::Job.enqueue(UserDelayedJob.new(self.id, self.password))
    UserMailer.account_confirmed_email_to_user(self).deliver
  end

  def save_as_complete!
    begin
      # isBarCodeAvailable is true means barcode is available we can assign to any user.
      isBarCodeAvailable = is_barcode_available_in_sierra

      unless isBarCodeAvailable
        Delayed::Worker.logger.info("User status is updating from #{self.status} to ")
        self.status = STATUS_LABELS['complete']
        self.save!
      end
    rescue StandardError => exception
      Delayed::Worker.logger.info("user details #{self.status}  #{exception.backtrace}")
    end
  end

  def is_barcode_available_in_sierra
    isBarCodeAvailable = false

    response = HTTParty.get(
      ENV['PATRON_MICROSERVICE_URL_V01'] + "?barcode=#{self.barcode}",
      headers:
        { 'Authorization' => "Bearer #{Oauth.get_oauth_token}",
          'Content-Type' => 'application/json' },
      timeout: 10
    )
    if (response.code == 404 && response.message == "Not Found")
      isBarCodeAvailable = true
    elsif (response.code == 409)
      isBarCodeAvailable = false
      LogWrapper.log('ERROR', {
        'method' => "is_barcode_available_in_sierra",
        'message' => "Duplicate patrons found for query. Barcode: #{self.barcode}"
      })
    elsif (response.code >= 500)
      LogWrapper.log('ERROR', {
        'method' => "is_barcode_available_in_sierra",
        'message' => "Internal Server error. Barcode: #{self.barcode}"
      })
      # raise InternalServerException.new(GENERIC_SERVER_ERROR[:code], GENERIC_SERVER_ERROR[:msg])
    end
    return isBarCodeAvailable
  end

  def find_unique_new_barcode
    # Enqueue a job to be performed as soon as the queuing system is free.
    begin
      # Note: user.pin is not getting serialized properly, hence passing as its own var.
      # Note: user.pin is no longer persisted to MLN db, taking us one step closer
      # to the goal of using Sierra as the source of truth.
      FindAvailableUserBarcodeJob.perform_later(user: self)
    rescue StandardError => exception
      LogWrapper.log('ERROR', {
          'method' => "#{model_name}.find_unique_new_barcode",
          'message' => "Sierra threw an error while looking for user(#{self.id || 'No ID Available'}) barcode in Sierra: (#{exception.message})"
        })
      raise exception
    rescue Exceptions => exception
    end
  end

  # Sends a request to the patron creator microservice.
  # Passes patron-specific information to the microservice s.a. name, email, and type.
  # The patron creator service creates a new patron record in the Sierra ILS, and comes back with
  # a success/failure response.
  # Accepts a response from the microservice, and returns.
  def send_request_to_patron_creator_service(pin)
    # Sierra supporting pin as password
    Delayed::Worker.logger.info("user pin details #{pin} ")
    Delayed::Worker.logger.info("user password details #{self.password} ")

    query = {
      'names' => ["#{self.last_name.upcase}", "#{self.first_name.upcase}"],
      'emails' => [email],
      'pin' => pin,
      'patronType' => patron_type,
      'patronCodes' => {
        'pcode1' => '-',
        'pcode2' => '-',
        'pcode3' => pcode3,
        'pcode4' => pcode4
      },
      'barcodes' => [self.barcode.present? ? "#{self.barcode}" : self.assign_barcode.to_s],
      addresses: [
        {
          lines: [
            "#{school.address_line_1}",
            "#{school.address_line_2}"
          ],
          type: 'a'
        }
      ],
      phones: [{
        number: school.phone_number,
        type: "t"
      }],
      varFields: [{
        fieldTag: "o",
        content: school.name
      }]
    }


    Delayed::Worker.logger.info("user request details #{query} ")

    response = HTTParty.post(
      ENV.fetch('PATRON_MICROSERVICE_URL_V02', nil),
      body: query.to_json,
      headers:
        { 'Authorization' => "Bearer #{Oauth.get_oauth_token}",
          'Content-Type' => 'application/json' },
      timeout: 10
    )

    Delayed::Worker.logger.info("user request details #{query} ")

    Delayed::Worker.logger.info("user response details #{response.code}  #{response.message}")

    case response.code
    when 201
      LogWrapper.log('DEBUG', {
          'message' => "The account with e-mail #{email} was
           successfully created from the micro-service!",
          'status' => response.code
        })
    when 400
      LogWrapper.log('ERROR', {
        'message' => "An error has occured when sending a request to the patron creator service",
        'status' => response.code,
        'responseData' => response.body
      })
      raise Exceptions::InvalidResponse, response["message"]["description"]
    else
      LogWrapper.log('ERROR', {
          'message' => "An error has occured when sending a request to the patron creator service",
          'status' => response.code,
          'responseData' => response.body
        })
      raise Exceptions::InvalidResponse, "Invalid status code of: #{response.code}"
    end
    response
  end

  def account_confirmed_email_to_user
    UserMailer.account_confirmed_email_to_user(self).deliver
  end

  # 404 - no records with the same e-mail were found
  # 409 - more then 1 record with the same e-mail was found
  # 200 - 1 record with the same e-mail was found
  def get_email_records(email)
    query = {
      'email' => email
    }

    response = HTTParty.get(
      ENV.fetch('PATRON_MICROSERVICE_URL_V01', nil),
      query: query,
      headers:
        {
          'Authorization' => "Bearer #{Oauth.get_oauth_token}",
          'Content-Type' => 'application/json'
        }
    )
    response = JSON.parse(response.body)
    case response['statusCode']
    when 404
      LogWrapper.log('DEBUG', {
         'message' => "No records found with the e-mail #{email} in Sierra database",
         'status' => response['statusCode'],
         'user' =>  { email: email }
        })
    when 409
      LogWrapper.log('DEBUG', {
         'message' => "The following e-mail #{email} has more then 1 record in the Sierra database with the same e-mail",
         'status' => response['statusCode'],
         'user' => { email: email }
        })
    when 200
      LogWrapper.log('DEBUG', {
         'message' => "The following e-mail #{email} has 1 other record in the Sierra database with the same e-mail",
         'status' => response['statusCode'],
         'user' => { email: email }
        })
      response = {statusCode: 200, message: 'This e-mail address already exists!'}
    else
      LogWrapper.log('ERROR', {
         'message' => "#{response}",
         'status' => response['statusCode'],
         'user' => { email: email }
        })
    end
      return response
  end

  def patron_type
    school.borough == 'QUEENS' ? 149 : 151
  end

  def pcode3
    return 1 if school.borough == 'BRONX'
    return 2 if school.borough == 'MANHATTAN'
    return 3 if school.borough == 'STATEN ISLAND'
    return 4 if school.borough == 'BROOKLYN'
    return 5 if school.borough == 'QUEENS'
  end

  # This returns the sierra code, not the school's zcode
  def pcode4
    school.sierra_code
  end
end
