class Book < ActiveRecord::Base
  include CatalogItemMethods
  has_paper_trail
  before_save :disable_papertrail
  before_update :enable_papertrail
  after_save :enable_papertrail

  attr_accessible :call_number, :cover_uri, :description, :details_url, :format, :id, :isbn, :notes, :physical_description, :primary_language, :publication_date, :statement_of_responsibility, :sub_title, :title, :catalog_choice
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

  def populate_missing_data
    if self.details_url.nil?
      puts "populate missing data for #{self.inspect}"
      if !self.catalog_choice.nil? && !self.catalog_choice.empty?
        # puts "populate missing data for #{self.inspect} from #{self.catalog_choice}"

        item = self.class.catalog_item self.catalog_choice
        # puts "item: ", item
        self.update_from_catalog_item item
        # puts "Success? ", item

      elsif !self.matching_api_items.nil? && self.matching_api_items.size == 1
        item = self.matching_api_items.first
        # puts "updating from item: #{item}"
        item = self.class.catalog_item item['id']
        # puts "updating from item item: #{item}"
        self.update_from_catalog_item item
      end
    end
  end

  def matching_api_items
    q = {}
    if !self.isbn.nil? && !self.isbn.empty?
      q[:isbn] = self.isbn

    else
      q[:title] = self.title
      q[:author] = self.statement_of_responsibility unless self.statement_of_responsibility.nil? || self.statement_of_responsibility.empty?
    end

    self.class.catalog_items_by_query q
  end

	def image_uri(size=:small)
    return nil if cover_uri.nil?

		deriv = 'S'
		deriv = 'M' if size == :medium
		deriv = 'L' if size == :large

		cover_uri.sub /Type=L/, "Type=#{deriv}"
	end

  def update_from_catalog_item(item)
		self.update_attributes :details_url => item['details_url']

		self.update_attributes :title => item['title'], :sub_title => item['sub_title'], :publication_date => item['publication_date'], :call_number => item['call_number'], :description => item['description'], :statement_of_responsibility => item['statement_of_responsibility']

		self.update_attributes :format => item['format']['name'] unless item['format'].nil?
		self.update_attributes :physical_description => item['physical_description'].join(';') unless item['physical_description'].nil?
		self.update_attributes :notes => item['notes'].join(';') unless item['notes'].nil?

		self.update_attributes :cover_uri => 'http://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=NYPL49807&password=CC68707&content=M&Return=1&Type=L&Value=' + item['isbns'].first unless item['isbns'].nil?
		self.update_attributes :isbn => item['isbns'].first if !item['isbns'].nil? && item['isbns'].size > 0
		self
  end


  def self.catalog_item(id)
    resp = self.api_call "titles/#{id}"
    # puts "cat item: #{resp.to_json}"
    return resp['title'] if resp.keys.include? 'title'
  end

  def self.catalog_item_by_query(q, scrape_fallback=false)
    res = self.catalog_items_by_query(q, scrape_fallback)
    res.first unless res.nil? || res.size == 0
  end

  def self.catalog_items_by_query(params, scrape_fallback=false)
    q = []
    # if !self.isbn.nil? && !self.isbn.empty?
    if !params[:isbn].nil?
      q << 'isbn:' + params[:isbn]
    else
      q << "title:(#{params[:title]})" unless params[:title].nil?
      q << "author:(#{params[:author]})" unless params[:author].nil? || params[:author].empty?
    end

    # puts "query: #{q.inspect}"

    resp = self.api_call 'titles', {:q => q.join(' '), :library => 'nypl', :search_type => 'custom'}

    if (!resp.keys.include?('titles') || resp['titles'].empty?) && scrape_fallback
      scrape_url = "http://#{CATALOG_DOMAIN}/search~S1/?searchtype=i&searcharg=#{params[:isbn]}"

      rows = self.scrape_css scrape_url, '.bibDetail tr', 1.day
      rows.each do |n|
        # puts " Considering row: #{n}"
        if (label = n.at_css('td.bibInfoLabel')) && label.text.strip.downcase == 'isbn'
          isbn = n.at_css('td.bibInfoData').text.strip.split(/ /).first
          puts "    Using alt isbn: #{isbn}"

          return self.catalog_items_by_query :isbn => isbn
        end
      end
    end

    return resp['titles'] if resp.keys.include? 'titles'

  end

  def self.update_by_catalog_id(id)
    item = self.catalog_item id
    Book.upsert_from_catalog_item item
  end

  def self.upsert_from_catalog_item(item)
		book = Book.find_or_initialize_by_details_url item['details_url']
    book.update_from_catalog_item item

    book
  end

  def create_teacher_set_version_on_update
    teacher_sets.all.each do |teacher_set|
      teacher_set.update_attributes(last_book_change: "updated-#{self.id}-#{self.title}")
    end
  end
end
