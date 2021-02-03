# frozen_string_literal: true

class User < ActiveRecord::Base
  include Exceptions
  include LogWrapper
  include Oauth


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, # this handles uniqueness of email automatically
         :timeoutable # adds session["warden.user.user.session"]["last_request_at"] which we use in sessions_controller

  # Makes getters and setters
  attr_accessor :pin


  # Validation's for email and pin only occurs when a user record is being
  # created on sign up. Does not occur when updating
  # the record.
  validates :first_name, :last_name, :presence => true
  validates_format_of :first_name, :last_name, :with => /\A[^0-9`!@;#\$%\^&*+_=\x00-\x19]+\z/
  validates_format_of :alt_email,:with => Devise::email_regexp, :allow_nil => true
  validates :alt_email, uniqueness: true, allow_nil: true
  validates :pin, :presence => true, format: { with: /\A\d+\z/, message: "may only contain numbers" },
    length: { is: 4, message: 'must be 4 digits.' }, on: :create
  validate :validate_pin_pattern, on: :create
  validate :validate_email_pattern, :on => :create

  has_many :holds

  belongs_to :school

  # Set default password if one is not set.
  # (TODO: Check if the default_password field is still relevant to the app.)
  # If alt_email is coming in empty, set it to NULL, so that we can save
  # to the database with the uniqueness constraint on the users.alt_email column.
  before_validation(on: :create) do
    self.password ||= User.default_password
    self.password_confirmation ||= User.default_password
    empty_alt_email_must_be_null
  end

  # If alt_email is coming in empty, set it to NULL, so that we can save
  # to the database with the uniqueness constraint on the users.alt_email column.
  before_validation :empty_alt_email_must_be_null, on: :update


  STATUS_LABELS = {'barcode_pending' => 'barcode_pending', 'complete' => 'complete'}.freeze


  ## NOTE: Validation methods, including this one, are called twice when
  # making new user from the admin interface. While not a behavior we want,
  # it doesn't currently pose a problem.
  def validate_email_pattern
    if (!defined?(email) || email.blank? || !email.index('@'))
      errors.add(:email, 'is required and should end in @schools.nyc.gov or another participating school address')
      return false
    end
    email.downcase.strip

    allowed_email_patterns = AllowedUserEmailMasks.where(active:true).pluck(:email_pattern)

    index = email.index('@')
    if (index && (allowed_email_patterns.include? email[index..-1]))
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


  def name(full=false)
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


  def assign_barcode
    LogWrapper.log('DEBUG', {
       'message' => "Begin assigning barcode to #{self.email}",
       'method' => "assign_barcode",
       'status' => "start",
       'user' => {email: self.email}
      })

    last_user_barcode = User.where('barcode < 27777099999999').order(:barcode).last.barcode
    self.assign_attributes({ barcode: last_user_barcode + 1})

    LogWrapper.log('DEBUG', {
       'message' => "Barcode has been assigned to #{self.email}",
       'method' => "assign_barcode",
       'status' => "end",
       'barcode' => "#{self.barcode}",
       'user' => {email: self.email}
      })
    return self.barcode
  end


  def check_barcode_found_in_sierra(barcode_to_check)
    # Ask the platform microservice api to ask Sierra if there is already a user
    # with the passed-in barcode.
    # Most users will have an equivalent user record in Sierra, if set up correctly.
    # New users and users whose records have been purged from Sierra might not.
    # Return "true" if a user is found, false otherwise.  Default to "false".
    # Throw an exception if called with malformed data.

    if barcode_to_check.blank?
      return false
    end

    @barcode_found_in_sierra = false

    response = HTTParty.get(
      ENV['PATRON_MICROSERVICE_URL_V01'] + "?barcode=#{barcode_to_check}",
      headers:
        { 'Authorization' => "Bearer #{Oauth.get_oauth_token}",
          'Content-Type' => 'application/json' },
      timeout: 10
    )

    case response.code
    when 200
      @barcode_found_in_sierra = true
      LogWrapper.log('DEBUG', {
          'method' => "#{model_name}.check_barcode_uniqueness_with_sierra",
          'message' => "patron service found user(#{barcode_to_check}) in Sierra",
          'status' => response.code
        })
    when 404
      LogWrapper.log('DEBUG', {
          'method' => "#{model_name}.check_barcode_uniqueness_with_sierra",
          'message' => "patron service did not find user(#{barcode_to_check}) in Sierra",
          'status' => response.code
        })
    when 409
      # Duplicate patrons found for query.  This is a data cleanliness/sync problem
      # but for the purpose of this method, we just care that the barcode is taken.
      @barcode_found_in_sierra = true
      LogWrapper.log('INFO', {
          'method' => "#{model_name}.check_barcode_uniqueness_with_sierra",
          'message' => "patron service found multiple user(#{barcode_to_check}) records in Sierra",
          'status' => response.code
        })
    else
      # Includes response of 500.  Be liberal and assume the barcode is free.
      LogWrapper.log('ERROR', {
          'method' => "#{model_name}.check_barcode_uniqueness_with_sierra",
          'message' => "patron service threw error while looking for user(#{barcode_to_check}) in Sierra",
          'status' => response.code,
          'responseData' => response.body
        })
      raise Exceptions::InvalidResponse, "Invalid status code of: #{response.code}"
    end

    return @barcode_found_in_sierra
  end


  # Checks pin patterns against
  # the following examples:
  # 1111, 2929, 0003, 5999.
  # Sierra will return the following
  # error message if PIN is invalid:
  # "PIN is not valid : PIN is trivial"
  def validate_pin_pattern
    if pin && pin&.scan(/(.)\1{2,}/)&.empty? && pin.scan(/(..)\1{1,}/)&.empty? == true
      true
    else
      errors.add(:pin, 'does not meet our requirements. Please try again.')
      false
    end
  end


  # Sends a request to the patron creator microservice.
  # Passes patron-specific information to the microservice s.a. name, email, and type.
  # The patron creator service creates a new patron record in the Sierra ILS, and comes back with
  # a success/failure response.
  # Accepts a response from the microservice, and returns.
  def send_request_to_patron_creator_service
    query = {
      'names' => [last_name.upcase + ', ' + first_name.upcase],
      'emails' => [email],
      'pin' => pin,
      'patronType' => patron_type,
      'patronCodes' => {
        'pcode1' => '-',
        'pcode2' => '-',
        'pcode3' => pcode3,
        'pcode4' => pcode4
      },
      'barcodes' => [self.barcode.present? ? self.barcode : self.assign_barcode.to_s],
      'addresses': [
        {
          'lines': [
            "#{school.address_line_1}",
            "#{school.address_line_2}"
          ],
          'type': 'a'
        }
      ],
      "phones": [{
        "number": school.phone_number,
        "type": "t"
      }],
      "varFields": [{
        "fieldTag": "o",
        "content": school.name
      }]
    }
    LogWrapper.log('DEBUG', {
       'message' => 'Request sent to patron creator service',
       'method' => 'send_request_to_patron_creator_service',
       'status' => 'start',
       'dataSent' => query
      })
    response = HTTParty.post(
      ENV['PATRON_MICROSERVICE_URL_V02'],
      body: query.to_json,
      headers:
        { 'Authorization' => "Bearer #{Oauth.get_oauth_token}",
          'Content-Type' => 'application/json' },
      timeout: 10
    )

    case response.code
    when 201
      LogWrapper.log('DEBUG', {
          'message' => "The account with e-mail #{email} was
           successfully created from the micro-service!",
          'status' => response.code
        })
    else
      LogWrapper.log('ERROR', {
          'message' => "An error has occured when sending a request to the patron creator service",
          'status' => response.code,
          'responseData' => response.body
        })
      raise Exceptions::InvalidResponse, "Invalid status code of: #{response.code}"
    end
  end


  # 404 - no records with the same e-mail were found
  # 409 - more then 1 record with the same e-mail was found
  # 200 - 1 record with the same e-mail was found
  def get_email_records(email)
    query = {
      'email' => email
    }

    response = HTTParty.get(
      ENV['PATRON_MICROSERVICE_URL_V01'],
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


  private

  # If alt_email is empty, set it to NIL.
  def empty_alt_email_must_be_null
    if self.alt_email.blank?
      self.alt_email = nil
    end
  end

end
