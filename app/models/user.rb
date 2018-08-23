class User < ActiveRecord::Base
  include Exceptions

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable # this handles uniqueness of email automatically

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
  :barcode, :alt_barcodes, :first_name, :last_name, :alt_email,
  :school_id, :pin

  # Makes getters and setters
  attr_accessor :pin

  # Validation's for email and pin only occurs when a user record is being
  # created on sign up. Does not occur when updating
  # the record.
  validates :school_id, :first_name, :last_name, :presence => true
  validates_format_of :email, with: /\@schools.nyc\.gov/, message: ' should end in @schools.nyc.gov', :on => :create
  validates_format_of :first_name, :last_name, :with => /\A[^0-9`!@;#\$%\^&*+_=\x00-\x19]+\z/
  validates_format_of :alt_email,:with => Devise::email_regexp, :allow_blank => true, :allow_nil => true
  validates :alt_email, uniqueness: true, allow_blank: true, allow_nil: true
  validates :pin, :presence => true, format: { with: /\A\d+\z/, message: "requires numbers only." },
    length: { is: 4, message: 'must be 4 digits.' }, on: :create
  validate :validate_pin_pattern, on: :create

  has_many :holds

  belongs_to :school

  # Set default password if one is not set
  before_validation(on: :create) do
    self.password ||= User.default_password
    self.password_confirmation ||= User.default_password
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
    Rails.logger.debug("assign_barcode: start")
    last_user_barcode = User.where('barcode < 27777099999999').order(:barcode).last.barcode
    self.assign_attributes({ barcode: last_user_barcode + 1})
    Rails.logger.debug("assign_barcode: end | Generated barcode #{self.barcode}.")
    return self.barcode
  end

  # Checks pin patterns against
  # the following examples:
  # 1111, 2929, 0003, 5999.
  # Sierra will return the following
  # error message if PIN is invalid:
  # "PIN is not valid : PIN is trivial"
  def validate_pin_pattern
    if pin.scan(/(.)\1{2,}/).empty? && pin.scan(/(..)\1{1,}/).empty? == true
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
    Rails.logger.debug("send_user_to_patron_creator_service: start")
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
      'barcodes' => [self.assign_barcode.to_s],
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
    Rails.logger.debug(
       {
        'status' => 'Request send to patron creator service',
        'dataSent' => query
       }
    )
    response = HTTParty.post(
      ENV['PATRON_MICROSERVICE_URL_V02'],
      body: query.to_json,
      headers:
        { 'Authorization' => "Bearer #{get_oauth_token}",
          'Content-Type' => 'application/json' },
      timeout: 10
    )
    case response.code
    when 201
      Rails.logger.debug(
        {
          'status' => "The account with e-mail #{email} was
           successfully created from the micro-service!"
        }
      )
    else
      Rails.logger.error JSON.parse(response.body).merge!(
        {
          'level' => 'Error',
          'level_code' => 3,
          'timestamp' => Time.now.iso8601
        }
      ).to_s
      raise Exceptions::InvalidResponse, "Invalid status code of: #{response.code}"
    end
  end

  def get_email_records(email)
    query = {
      'email' => email
    }

    response = HTTParty.get(
      ENV['PATRON_MICROSERVICE_URL_V01'],
      query: query,
      headers:
        {
          'Authorization' => "Bearer #{get_oauth_token}",
          'Content-Type' => 'application/json'
        }
    )
    response = JSON.parse(response.body)
    if response['statusCode'] != 404
      Rails.logger.error response.merge!(
        {
          'level' => 'Error',
          'level_code' => 3,
          'timestamp' => Time.now.iso8601
        }
      ).to_s
    else
      Rails.logger.debug "#{response}"
    end
    return response
  end

  def get_oauth_token
    response = HTTParty.post(ENV['ISSO_OAUTH_TOKEN_URL'],
      body: {
        grant_type: 'client_credentials',
        client_id: ENV['ISSO_CLIENT_ID'],
        client_secret: ENV['ISSO_CLIENT_SECRET']
      })
    case response.code
    when 200
      return JSON.parse(response.body)['access_token']
    else
      Rails.logger.error(
        {
          message: 'Error in receiving response from ISSO NYPL TOKEN SERVICE',
          type: 'Error',
          level_code: 3,
          timestamp: Time.now.iso8601,
          statusCode: response.code
        }
      )
      raise InvalidResponse, "Invalid status code of: #{response.code}"
    end
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

  def pcode4 # This returns the sierra code, not the school's zcode
    school.sierra_code
  end
end
