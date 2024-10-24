# frozen_string_literal: true

class Book < ActiveRecord::Base

  # NOTE: The ISBN field in the database refers to a standard number; sometimes this is an ISBN.
  include CatalogItemMethods
  include Oauth
  include Exceptions

  has_paper_trail
  before_save :disable_papertrail
  before_update :enable_papertrail
  after_save :enable_papertrail

  attr_accessor :catalog_choice

  # attr_accessor :matching_api_items

  # has_and_belongs_to_many :authors
  has_many :teacher_set_books, :dependent => :destroy
  has_many :teacher_sets, through: :teacher_set_books

  # turn this off this obsolete validation so that we can run tests on book creation; otherwise you get this error: `Need to set ENVs`
  # validate do |book|
  #   BookValidator.new(book).validate
  # end

  # turn off this obsolete callback so that we can run tests on book creation; otherwise you get this error: `Need to set ENVs`
  # after_save :populate_missing_data
  after_commit :create_teacher_set_version_on_update, on: :update

  validates_uniqueness_of :bnumber, allow_blank: true

  def self.ransackable_associations(auth_object = nil)
    ["teacher_set_books", "teacher_sets", "versions"]
  end

  def self.ransackable_attributes(auth_object = nil)
     ["bib_code_3", "bnumber", "call_number", "cover_uri", "created_at", "description", "details_url", "format", "id", "id_value", "isbn", "notes", "physical_description", "primary_language", "publication_date", "statement_of_responsibility", "sub_title", "title", "updated_at"]
  end

  # Unused method
  # def populate_missing_data
  #   if self.details_url.nil?
  #     puts "populate missing data for #{self.inspect}"
  #     if !self.catalog_choice.nil? && !self.catalog_choice.empty?
  #       # puts "populate missing data for #{self.inspect} from #{self.catalog_choice}"

  #       item = self.class.catalog_item self.catalog_choice
  #       # puts "item: ", item
  #       self.update_from_catalog_item item
  #       # puts "Success? ", item

  #     elsif !self.matching_api_items.nil? && self.matching_api_items.size == 1
  #       item = self.matching_api_items.first
  #       # puts "updating from item: #{item}"
  #       item = self.class.catalog_item item['id']
  #       # puts "updating from item item: #{item}"
  #       self.update_from_catalog_item item
  #     end
  #   end
  # end

  # Unused method
  # def matching_api_items
  #   q = {}
  #   if !self.isbn.nil? && !self.isbn.empty?
  #     q[:isbn] = self.isbn

  #   else
  #     q[:title] = self.title
  #     q[:author] = self.statement_of_responsibility unless self.statement_of_responsibility.nil? || self.statement_of_responsibility.empty?
  #   end

  #   self.class.catalog_items_by_query q
  # end


  def image_uri(size=:small)
    return nil if cover_uri.nil?

    deriv = 'S'
    deriv = 'M' if size == :medium
    deriv = 'L' if size == :large

    cover_uri.sub /Type=L/, "Type=#{deriv}"
  end


  # def update_from_catalog_item(item)
  #   self.update :details_url => item['details_url']

  #   self.update :title => item['title'], :sub_title => item['sub_title'], :publication_date => item['publication_date'], 
  #               :call_number => item['call_number'], :description => item['description'], 
  #               :statement_of_responsibility => item['statement_of_responsibility']

  #   self.update :format => item['format']['name'] unless item['format'].nil?
  #   self.update :physical_description => item['physical_description'].join(';') unless item['physical_description'].nil?
  #   self.update :notes => item['notes'].join(';') unless item['notes'].nil?
  #   url_path = 'http://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=NYPL49807&password=CC68707&content=M&Return=1&Type=L&Value='
  #   self.update :cover_uri => url_path + item['isbns'].first unless item['isbns'].nil?
  #   self.update :isbn => item['isbns'].first if !item['isbns'].nil? && !item['isbns'].empty?
  #   self
  # end


  def self.catalog_item(id)
    resp = self.api_call "titles/#{id}"
    # puts "cat item: #{resp.to_json}"
    return resp['title'] if resp.keys.include? 'title'
  end

  # Unused method
  # def self.catalog_item_by_query(q, scrape_fallback=false)
  #   res = self.catalog_items_by_query(q, scrape_fallback)
  #   res.first unless res.nil? || res.empty?
  # end

  # Unused method
  # def self.catalog_items_by_query(params, scrape_fallback=false)
  #   q = []
  #   # if !self.isbn.nil? && !self.isbn.empty?
  #   if !params[:isbn].nil?
  #     q << 'isbn:' + params[:isbn]
  #   else
  #     q << "title:(#{params[:title]})" unless params[:title].nil?
  #     q << "author:(#{params[:author]})" unless params[:author].nil? || params[:author].empty?
  #   end

  #   # puts "query: #{q.inspect}"

  #   resp = self.api_call 'titles', {:q => q.join(' '), :library => 'nypl', :search_type => 'custom'}

  #   if (!resp.keys.include?('titles') || resp['titles'].empty?) && scrape_fallback
  #     scrape_url = "http://#{CATALOG_DOMAIN}/search~S1/?searchtype=i&searcharg=#{params[:isbn]}"

  #     rows = self.scrape_css scrape_url, '.bibDetail tr', 1.day
  #     rows.each do |n|
  #       # puts " Considering row: #{n}"
  #       if (label = n.at_css('td.bibInfoLabel')) && label.text.strip.downcase == 'isbn'
  #         isbn = n.at_css('td.bibInfoData').text.strip.split(/ /).first
  #         puts "    Using alt isbn: #{isbn}"

  #         return self.catalog_items_by_query :isbn => isbn
  #       end
  #     end
  #   end

  #   return resp['titles'] if resp.keys.include? 'titles'
  # end

  # Unused method
  # def self.update_by_catalog_id(id)
  #   item = self.catalog_item id
  #   Book.upsert_from_catalog_item item
  # end

  # Unused method
  # def self.upsert_from_catalog_item(item)
  #   book = Book.find_or_initialize_by_details_url item['details_url']
  #   book.update_from_catalog_item item

  #   book
  # end


  def create_teacher_set_version_on_update
    teacher_sets.all.each do |teacher_set|
      teacher_set.update(last_book_change: "updated-#{self.id}-#{self.title}")
    end
  end

  def update_from_isbn
    response = send_request_to_bibs_microservice
    return if !@book_found

    begin
      book_attributes = JSON.parse(response.body)['data'][0]
      self.update(
        bnumber: book_attributes['id'],
        title: book_attributes['title'],
        publication_date: book_attributes['publishYear'],
        primary_language: (book_attributes['lang'] ? book_attributes['lang']['name'] : nil),
        details_url: "http://catalog.nypl.org/record=b#{book_attributes['id']}~S1",
        call_number: var_field(book_attributes, '091'),
        description: var_field(book_attributes, '520'),
        physical_description: var_field(book_attributes, '300'),
        format: var_field(book_attributes, '020'),
        cover_uri: "http://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=NYPL49807&password=CC68707&content=M&Return=1&Type=L&Value=#{isbn}",
        bib_code_3: fixed_field(book_attributes, '31', true)
      )
    rescue => e
      # catch any error such as string field is receiving more than 255 characters or an expected attribute is missing
      LogWrapper.log('ERROR', {
        'message' => "#{e.message[0..200]}...\nBacktrace=#{e.backtrace}.",
        'method' => 'method'
      })
    end
  end

  private

  # Sends a request to the bibs microservice.
  def send_request_to_bibs_microservice
    response = HTTParty.get(
      ENV.fetch('BIBS_MICROSERVICE_URL_V01', nil) + "?standardNumber=#{isbn}",
      headers:
        { 'Authorization' => "Bearer #{Oauth.get_oauth_token}",
          'Content-Type' => 'application/json' },
      timeout: 10
    )

    case response.code
    when 200
      @book_found = true
      LogWrapper.log('DEBUG', {
          'message' => "The bibs service responded with the book JSON.",
          'status' => response.code
        })
    when 404
      @book_found = false
      LogWrapper.log('ERROR', {
          'message' => "The bibs service could not find the book with ISBN=#{isbn}",
          'status' => response.code
        })
    else
      LogWrapper.log('ERROR', {
          'message' => "An error has occured when sending a request to the bibs service",
          'status' => response.code,
          'responseData' => response.body
        })
      raise Exceptions::InvalidResponse, "Invalid status code of: #{response.code}"
    end

    return response
  end
  
  def var_field(book_attributes, marcTag)
    begin
      book_attributes['varFields'].detect{ |hash| hash['marcTag'] == marcTag }['subfields'].map{ |x| x['content']}.join(', ')
    rescue
      return nil
    end
  end

  # This method returns Fixed Field values from bib response
  # eg: book_attributes = "fixedFields"=> {"24"=>{"label"=>"Language", "value"=>"eng", "display"=>"English"}
  # Return result value = "a"
  def fixed_field(book_attributes, marcTag, value=nil)
    begin
      fixed_field = book_attributes['fixedFields'][marcTag]
      value.present? ? fixed_field['value'] : fixed_field['display']
    rescue
      return nil
    end
  end
end
