# encoding: UTF-8
# frozen_string_literal: true

class TeacherSet < ActiveRecord::Base
  include CatalogItemMethods
  include LogWrapper
  include TeacherSetsHelper
  include MlnException
  include MlnResponse
  include LogWrapper

  has_paper_trail
  before_save :disable_papertrail
  before_update :enable_papertrail
  after_save :enable_papertrail

  attr_accessor :subject, :subject_key, :suitabilities_string, :note_summary, :note_string, :slug

  has_many :teacher_set_notes #, :as => :notes
  has_many :teacher_set_books, :dependent => :destroy
  has_many :books, :through => :teacher_set_books #, -> { order "teacher_set_books.rank desc" }
  has_many :holds
  has_many :subject_teacher_sets, dependent: :delete_all
  has_many :subjects, through: :subject_teacher_sets

  accepts_nested_attributes_for :books, :allow_destroy => true

  validates_associated :books

  validates_uniqueness_of :bnumber

  before_create :make_slug

  KEY_WORDS = ["NYC"]
  
  AVAILABLE = 'available'
  UNAVAILABLE = 'unavailable'

  PRE_K_VAL = -1
  K_VAL = 0

  AVAILABILITY_LABELS = {'available' => 'Available', 'unavailable' => 'Checked Out'}
  SET_TYPE_LABELS = {'single' => 'Book Club Set', 'multi' => 'Topic Sets'}
  TOPIC_SET = 'Topic Set'
  BOOK_CLUB_SET = 'Book Club Set'
  SIERRA_NYPL = 'sierra-nypl'


  FULLTEXT_COLUMNS = ['title', 'description', 'contents']

  def new_or_pending_holds
    # puts "holds: #{holds.where(:status => ['new','pending'])}"
    holds.where(:status => ['new','pending'])
  end

  def held_by?(user)
    pending_holds_for_user(user).count > 0
  end

  def availability_string
    AVAILABILITY_LABELS[self.availability]
  end
  
  # Get teacher-set record by bib_id
  def self.get_teacher_set_by_bnumber(bib_id)
    TeacherSet.where(bnumber: "b#{bib_id}").first
  end

  def pending_holds_for_user(user)
    if user
      holds.where(:user_id => user.id, :status => ['new','pending']).order('created_at desc')
    else
      []
    end
  end
  
  # Get all teacher-set status holds except for cancelled and closed.
  def ts_holds_count
    ts_holds = holds.where.not(status: ['cancelled'])
    ts_holds.present? ? ts_holds.sum(:quantity) : nil
  end

  # Current user Teacher set holds count
  def holds_count_for_user(user, hold_id=nil)
    holds = holds_for_user(user, hold_id)
    holds.present? ? holds.sum(:quantity) : nil
  end

  # Current user Teacher set holds
  def holds_for_user(user, hold_id)
    return [] unless user
    
    if hold_id.present?
      ts_holds_by_user_and_hold_id(user, hold_id)
    else
      ts_holds_by_user(user)
    end
  end
  
  def availability
    self.available_copies.to_i > 0 ? AVAILABLE : UNAVAILABLE
  end

  # calculate teacher-set available copies while creating/cancelling the hold
  # quantity = No.of holds requested while creation of hold.
  def calculate_available_copies(status, quantity=nil, current_user=nil, hold_id=nil)
    if status == 'cancelled'
      user_holds_count = holds_count_for_user(current_user, hold_id).to_i
      available_copies = self.available_copies.to_i + user_holds_count
    else
      available_copies = self.available_copies - quantity.to_i
    end
    available_copies
  end

  def update_teacher_set_availability_in_db(status, quantity=nil, current_user=nil, hold_id=nil)
    available_copies = calculate_available_copies(status, quantity, current_user, hold_id)
    self.available_copies = available_copies
    self.availability = availability
    self.save!
  end

  # Update teacher-set availability while creation/cancellation of hold.
  def update_teacher_set_availability_in_elastic_search
    body = {
     :availability => self.availability,
     :available_copies => self.available_copies,
    }
    ElasticSearch.new.update_document_by_id(self.id, body)
  end

  # Get teacher-set holds by user and hold_id
  def ts_holds_by_user_and_hold_id(user, hold_id)
    holds.where(:user_id => user.id, :id => hold_id).where.not(status: ['cancelled', 'closed'])
  end
  
  # Get teacher-set holds by user.
  def ts_holds_by_user(user)
    holds.where(:user_id => user.id).where.not(status: ['cancelled', 'closed'])
  end
  
  def make_slug
    # check for nil title otherwise parameterize will fail
    parameterized_title = (self.title || '').parameterize
    self.slug ||= [parameterized_title, rand(36**6).to_s(36)].join("-")
  end

  # Poor man's subject... TODO: replace with column in DB
  def subject
    area_of_study
  end

  def has_subject(title)
    # puts "subjects for #{title}: #{self.subjects.select { |s| puts "'#{s.title}' == '#{title}'";  s.title == title }.inspect}"
    !self.subjects.select { |s| s.title == title }.empty?
  end

  def subject_key
    subject.parameterize if subject.present?
  end

  def suitabilities_string
    suitabilities.join('; ')
  end

  # Fetch first book cover uri, with size = (:small|:medium|:large)
  def image_uri(size = :small)
    books.first.image_uri(size) if !books.empty?
  end
  
  def self.initialize_teacher_set(bib_id)
    TeacherSet.where(bnumber: "b#{bib_id}").first_or_initialize
  end
    
  def self.create_or_update_teacher_set(req_body)
    bib_id = req_body['id']

    if req_body["suppressed"]
      # If bib request-body has suppressed value as true then delete teacher-set from database and elastic-search.
      teacher_set = self.delete_teacher_set(bib_id, req_body["suppressed"])
      if teacher_set.destroyed?
        LogWrapper.log('INFO', {message: "message: #{BIB_RECORD_SUPPRESSED_REMOVED_FROM_MLN[:msg]}",
                       method: __method__, bib_id: bib_id, teacher_set_id: teacher_set.id, suppressed: req_body["suppressed"]})
        raise SuppressedBibRecordException.new(BIB_RECORD_SUPPRESSED_REMOVED_FROM_MLN[:code], BIB_RECORD_SUPPRESSED_REMOVED_FROM_MLN[:msg])
      end
    end
    teacher_set = self.initialize_teacher_set(bib_id)
    # Calls Bib service for items.
    # Calculates the total number of items and available items in the list.
    ts_items_info = teacher_set.get_items_info_from_bibs_service(bib_id)

    teacher_set.instance_variable_set(:@req_body, req_body)
    teacher_set.update_teacher_set_attributes_from_bib_request(ts_items_info)

    # clean up the area of study field to match the subject field string rules.
    teacher_set.clean_primary_subject

    # update all teacher-set subjects.
    teacher_set.update_subjects_via_api(teacher_set.all_var_fields('650'))

    # Create/Update all teacher-set notes.
    teacher_set.update_notes(teacher_set.var_field_data('500', true))

    # Create/Update all books.
    teacher_set.update_included_book_list(req_body)

    # When ever there is a create/update on bib than need to create/update the data in elastic search document.
    teacher_set.create_or_update_teacherset_document_in_es
    teacher_set
  end

  # Update teacher-set table from bib request body.
  def update_teacher_set_attributes_from_bib_request(ts_items_info)
    self.update(
      title: @req_body['title'],
      call_number: var_field_data('091'),
      description: var_field_data('520'),
      edition: var_field_data('250'),
      isbn: var_field_data('020'),
      primary_language: fixed_field('24'),
      publisher: var_field_data('260'),
      contents: var_field_data('505'),
      area_of_study: var_field_data('690', false),
      physical_description: var_field_data('300', false),
      details_url: "http://legacycatalog.nypl.org/record=b#{@req_body['id']}~S1",
      # If Grade value is Pre-K saves as -1 and Grade value is 'K' saves as '0' in TeacherSet table.
      grade_begin: grade_or_lexile_array('grade')[0] || '',
      grade_end: grade_or_lexile_array('grade')[1] || '',
      lexile_begin: grade_or_lexile_array('lexile')[0] || '', # NOTE: lexile functionality has been taken off
      lexile_end: grade_or_lexile_array('lexile')[1] || '', # NOTE: lexile functionality has been taken off
      available_copies: ts_items_info[:available_count],
      total_copies: ts_items_info[:total_count],
      availability: ts_items_info[:availability_string],
      set_type: derive_set_type(var_field_data('526'))
    )
    self
  end
  
  # Create or update teacherset document in elastic search.
  def create_or_update_teacherset_document_in_es
    body = teacher_set_info
    elastic_search = ElasticSearch.new
    begin
      # If teacherset document is found in elastic search than update document in ES.
      elastic_search.update_document_by_id(body[:id], body)
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
      # If teacherset document not found in elastic search than create document in ES.
      resp = elastic_search.create_document(body[:id], body)
      if resp['result'] == "created"
        LogWrapper.log('DEBUG', {'message' => "Successfullly created elastic search doc. Teacher set id #{body[:id]}",'method' => __method__})
      else
        LogWrapper.log('ERROR', {'message' => "Elastic search document not created/updated. Error: #{e.message}, ts-id: #{body[:id]}", 
                                 'method' => __method__})
      end
    rescue StandardError => e
      LogWrapper.log('ERROR', {'message' => "Error occured while updating elastic search doc. Teacher set id #{body[:id]}, message: #{e.message}",
                               'method' => __method__})
      raise ElasticsearchException.new(ELASTIC_SEARCH_STANDARD_EXCEPTION[:code], ELASTIC_SEARCH_STANDARD_EXCEPTION[:msg])
    end
  end

  # Delete teacher-set record from db and elastic search.
  def self.delete_teacher_set(bib_id, suppressed = false)
    # Get teacher-set record by bib_id
    teacher_set = self.get_teacher_set_by_bnumber(bib_id)
    unless teacher_set.present?
      if suppressed
        raise SuppressedBibRecordException.new(BIB_RECORD_SUPPRESSED_NOT_ADDED_TO_MLN[:code],BIB_RECORD_SUPPRESSED_NOT_ADDED_TO_MLN[:msg])
      else
        raise BibRecordNotFoundException.new(BIB_RECORD_NOT_FOUND[:code],BIB_RECORD_NOT_FOUND[:msg])
      end
    end
    
    # Delete teacher-set record
    resp = teacher_set.destroy
    # After deletion of teacherset data from db than delete teacherset doc from elastic search
    teacher_set.delete_teacherset_record_from_es if resp.destroyed?
    teacher_set
  end

  # When Delete request comes from sierra, than delete teacher set document in elastic search.
  def delete_teacherset_record_from_es
    ts_id = self.id
    ElasticSearch.new.delete_document_by_id(ts_id)
  rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
    raise ElasticsearchException.new(TEACHER_SET_NOT_FOUND_IN_ES[:code], TEACHER_SET_NOT_FOUND_IN_ES[:msg])
  rescue StandardError => e
    LogWrapper.log('ERROR', {'message' => "Error occured while deleting elastic search doc. Teacher set id #{ts_id}. Error: #{e.message}",
                             'method' => __method__})
    raise ElasticsearchException.new(ELASTIC_SEARCH_STANDARD_EXCEPTION[:code], ELASTIC_SEARCH_STANDARD_EXCEPTION[:msg])
  end
  
  # Make request input body to create teacherset document in elastic search.
  # Input param ts_obj eg: <TeacherSet:0x00007fd79383a640 id: 350, title: "Step",call_number: "Teacher",
  # description: "Book", details_url: "http://catalog.nypl.org/record=b21378444~S1","updated-7571-Step up to the plate, Maria Singh">
  # Expected response from this method {:title=>"Step Up", :description=> "Book", :contents=>"Step Up", :id=>350}
  def teacher_set_info
    created_at = self.created_at.present? ? self.created_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
    updated_at = self.updated_at.present? ? self.updated_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
    availability = self.availability.present? ? self.availability.downcase : nil

    subjects_arr = []
    # Teacherset have has_many relationship with subjects
    # Get teacherset subjects from db than update in elastic search.
    if self.subjects.present?
      self.subjects.distinct.each do |subject|
        subjects_hash = {}
        s_created_at = subject.created_at.present? ? subject.created_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
        s_updated_at = subject.updated_at.present? ? subject.updated_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
        subjects_hash[:id] = subject.id
        subjects_hash[:title] = subject.title
        subjects_hash[:created_at] = s_created_at
        subjects_hash[:updated_at] = s_updated_at
        subjects_arr << subjects_hash
      end
    end
    {title: self.title, description: self.description, contents: self.contents, 
      id: self.id.to_i, details_url: self.details_url, grade_end: self.grade_end, 
      grade_begin: self.grade_begin, availability: availability, total_copies: self.total_copies,
      call_number: self.call_number, language: self.language, physical_description: self.physical_description,
      primary_language: self.primary_language, created_at: created_at, updated_at: updated_at,
      available_copies: self.available_copies, bnumber: self.bnumber, set_type: self.set_type,
      area_of_study: self.area_of_study, subjects: subjects_arr }
  end

  def self.for_query(params)
    sets = self.paginate(:page => params[:page])

    unless params[:keyword].nil? || params[:keyword].empty?
      # sets = sets.where("title ILIKE ?", "%#{params[:keyword]}%")
      # sets = sets.where("to_tsvector('simple', #{cols}) @@ to_tsquery(?)", "%#{params[:keyword].gsub(/\ /, '|')}%")
      # TODO: This should really be a fulltext search index, but ran out of time
      clauses = []
      FULLTEXT_COLUMNS.each do |c|
        clauses << "#{table_name}.#{c} ILIKE ?"
      end
      # Match on topics too:
      clauses << "#{table_name}.id IN (SELECT _S2T.teacher_set_id FROM subjects _S INNER JOIN subject_teacher_sets _S2T ON _S2T.subject_id=_S.id \
                  WHERE _S.title ILIKE ?)"

      vals = [].fill("%#{params[:keyword]}%", 0, clauses.length)
      sets = sets.where(clauses.join(' OR '), *vals)
    end

    [:grade_begin, :grade_end, :lexile_begin, :lexile_end].each do |k|
      next if params[k].nil?

      params[k] = params[k].to_i if params[k].present?
    end

    # Grade & Lexile ranges:
    # If grade/lexile range specified, ensure sets have ranges that cover some part of specified range
    # e.g. grade_begin=4&grade_end=6 returns sets with ranges 4-6, 4-5, 5-7, 6-8, 5-null, etc.
    # e.g. grade_begin=8&grade_end=[null] returns sets with ranges 8-12, 8-null, etc.
    # e.g. grades = {Pre-K => -1, K => 0}
    # e.g. grade_begin=-1&grade_end=0 returns sets with ranges Pre-k to 1, Pre-k to K, K-3, etc.
    # Note these clauses purposefully include sets with null grade/lexile ranges by stakeholder request
    ['grade','lexile'].each do |prop|
      begin_prop = "#{prop}_begin"
      end_prop = "#{prop}_end"
      null_clause = "(#{begin_prop} IS NULL AND #{end_prop} IS NULL)"
      unless params[begin_prop].nil?
        sets = sets.where("#{begin_prop} >= ? OR #{end_prop} >= ? OR #{null_clause}", params[begin_prop], params[begin_prop])
      end
      unless params[end_prop].nil?
        sets = sets.where("#{begin_prop} <= ? OR #{end_prop} <= ? OR #{null_clause}", params[end_prop], params[end_prop])
      end
    end

    # Internal name for "Tags" is subject
    if params[:subjects].present?
      params[:subjects].each_with_index do |s, i|
        # Each selected Subject facet requires its own join:
        join_alias = "S2T#{i}"
        next unless s.match? /^[0-9]+$/

        sets = sets.joins("INNER JOIN subject_teacher_sets #{join_alias} ON #{join_alias}.teacher_set_id=teacher_sets.id AND \
                          #{join_alias}.subject_id=#{s}")
      end
    end

    # Internal name for "Subject" is area_of_study
    if params['area of study'].present?
      sets = sets.where("area_of_study = ?", params['area of study'].join())
    end

    # Internal name for "set type" is set_type
    unless params['set type'].nil?
      sets = sets.where("set_type = ?", params['set type'].join())
    end

    if params[:language].present?
      sets = sets.where("language IN (?) OR primary_language IN (?)", params[:language], params[:language])
    end
    if !params[:availability].nil? && !params[:availability].empty?
      sets = sets.where("availability IN (?)", params[:availability])
    end

    # Sort most available first with id as tie breaker to ensure consistent sorts
    sets.order('availability ASC, available_copies DESC, id DESC')
  end

  def self.facets_for_query(qry)
    cache_key = qry.to_sql.sub /\ LIMIT.*/, ''
    cache_key = Digest::MD5.hexdigest cache_key.parameterize
    # NOTE: the expiry was 1.day, changing to 8.hour to see teacher set fixes in human-administered time.
    # TODO: take this cache expiration timeout constant out into a properties file.
    Rails.cache.fetch "facets-#{cache_key}", :expires_in => 8.hour do
      facets = []

      # Facets for language, availability, type, and subject are pretty basic GROUPBYs:
      [
        { :label => 'language',
          :column => :primary_language
        },
        { :label => 'availability',
          :column => 'availability',
          :value_map => self::AVAILABILITY_LABELS
        },
        { :label => 'set type',
          :column => 'set_type'
        },
        { :label => 'area of study',
          :column => 'area_of_study'
        }
      ].each do |config|

        facets_group = {:label => config[:label], :items => []}

        qry.group(config[:column]).where("#{config[:column].to_s} IS NOT NULL").count.each do |(value,count)|
          label = value
          unless config[:value_map].nil?
            label = config[:value_map][value]
            next if label.nil?
          end
          facets_group[:items] << {
            :value => value,
            :label => label,
            :count => count
          }

        end

        facets << facets_group
      end

      # Collect primary subjects for restricting subjects
      primary_subjects = []

      unless (subjects_facet = facets.select { |f| f[:label] == 'area of study' }).nil?
        primary_subjects = subjects_facet.first[:items].map { |s| s[:label] }
      end

      # Tags
      subjects_facets = {:label => 'subjects', :items => []}
      _qry = qry.joins(:subjects).where('subjects.title NOT IN (?)', primary_subjects).group('subjects.title', 'subjects.id')
      # Restrict to min_count_for_facet (5). Used to only activate if no subjects currently selected,
      # but let's make it 5 consistently now.
      #if !_qry.to_sql.include?('JOIN subject_teacher_sets')
      _qry = _qry.having('count(*) >= ?', Subject::MIN_COUNT_FOR_FACET)
      _qry.count.each do |(vals, count)|
        (label, val) = vals
        subjects_facets[:items] << {
          :value => val,
          :label => label,
          :count => count
        }
      end

      facets << subjects_facets

      # Specify desired order of facets:
      facets.sort_by! do |f|
        ind = ['area of study', 'subjects', 'language','set type','availability'].index f[:label]
        ind.nil? ? 1000 : ind
      end

      # Set order of facet vals:
      # Not sure why activerecord query with group() is ignoring order(), so we'll order here:
      facets.each do |f|
        f[:items].sort_by! { |i| i[:label] }
      end

      facets
    end

    
  end

  def as_json(options = { })
    h = super(options)
    h[:subject] = subject
    h[:subject_key] = subject_key
    h[:suitabilities_string] = suitabilities_string
    h
  end

  # old and unused method
  # def self.upsert_from_catalog_id(id)
  #   item = self.api_call "titles/#{id}"
  #   self.upsert_from_catalog_item item['title'] unless item.nil? || item['title'].nil?
  # end


  # def self.upsert_from_catalog_item(item)
  #   # book = self.find_or_initialize_by_details_url item['details_url']
  #   book = self.find_or_initialize_by_id item['id'].to_i
  #   puts "  New Set!: #{book.id}" unless book.persisted?
  #   book.update_from_catalog_item item
  #   book
  # end


  # def update_from_catalog_item(item)
  #   # puts "create book: #{item['id']}:  #{id}"
  #   # set = TeacherSet.find_or_initialize_by_id id
  #   title = item['title']
  #   title.sub! /\WGr\.\W[0-9kK]-[0-9]+/, ''
  #   title.sub! /\W\(Teacher Set\)\W*$/, ''

  #   # title.sub!

  #   self.update({
  #     :title => title,
  #     :call_number => item['call_number'],
  #     :description => item['description'],
  #     :details_url => item['details_url'],
  #     :edition => item['edition'],
  #     :publication_date => item['publication_date'],
  #     :statement_of_responsibility => item['statement_of_responsibility'],
  #     :sub_title => item['sub_title'],
  #     :contents => item['contents'].join("\n")
  #   })

  #   self.update :isbn => item['isbns'].first if !item['isbns'].nil? && !item['isbns'].empty?
  #   self.update :language => item['languages'].first['name'] if !item['languages'].empty?
  #   self.update :physical_description => item['physical_description'].first if !item['physical_description'].empty?
  #   self.update :publisher => item['publishers'].first['name'] if !item['publishers'].empty?
  #   self.update :series => item['series'].first['name'] if !item['series'].nil? && !item['series'].empty?

  #   grade_begin = nil
  #   grade_end = nil
  #   if item['suitabilities'].present?
  #     item['suitabilities'].each do |suit|
  #       # Parse grade suitablility (e.g. 4-12, 4-+)
  #       # If grade_end is '+', store null
  #       m = suit['name'].match /([0-9K]+)-([0-9+]+)/
  #       unless m.nil?
  #         # Apply values, making sure values are <= 12 (i.e. watch out for misentered lexiles)
  #         if m[1].to_i <= 12
  #           v = m[1].to_i
  #           grade_begin = grade_begin.nil? ? v : [grade_begin, v].min
  #         end

  #         if m[2].to_i <= 12
  #           v = m[2].to_i
  #           grade_end = grade_end.nil? ? v : [grade_end, v].max
  #         end
  #       end
  #     end
  #   end
  #   self.update :grade_begin => grade_begin, :grade_end => grade_end

  #   lang = nil
  #   unless item['primary_language'].nil? || item['primary_language'].empty?
  #     lang = item['primary_language']['name']
  #     lang = nil if ['Undetermined'].include? lang
  #   end
  #   self.update :primary_language => lang

  #   self.teacher_set_notes.destroy_all
  #   item['notes'].each do |n|
  #     self.teacher_set_notes.push TeacherSetNote.new :content => n
  #   end

  #   if self.bnumber.nil?
  #     url = "http://#{CATALOG_DOMAIN}/search~S1/?searchtype=c&searcharg=#{URI::encode(self.call_number)}"
  #     # TODO: take the 1.day constant out into a properties file.
  #     # NOTE: the expiry was 1.day, changing to 8.hour to see fixes in human-administered time.
  #     content = self.class.scrape_content url, 8.hour
  #     # puts "  Getting by call num: #{url}"
  #     # sleep 0.5
  #     doc = Nokogiri::HTML(content)

  #     puts "    Getting bnumber from #{url}"

  #     permalink = doc.at_css('a:contains("Permanent link for this record")')

  #     if permalink.nil?
  #       item_url = nil
  #       if !(item_links = doc.css('.briefcitItems a')).empty?
  #         # puts "  parsing as: 2"
  #         item_links = item_links.select { |l| l.text.include? 'View Full Record' }
  #         item_url = "http://#{CATALOG_DOMAIN}#{item_links.first[:href]}" unless item_links.empty?

  #       # If that fails, look for "Teacher Set ..." links
  #       # if item_url.nil? && !(item_links = doc.css('.browseEntryData a')).empty?
  #       elsif !(item_links = doc.css('.bibItemsEntry a', '.browseEntryData a')).empty?
  #         # puts "  parsing as: 3"
  #         item_links = item_links.select { |l| l.text.include? 'Teacher Set' }
  #         item_url = "http://#{CATALOG_DOMAIN}#{item_links.first[:href]}" unless item_links.empty?
  #       end

  #       # If an item_url found, follow it to find the permalink
  #       unless item_url.nil?
  #         # puts "    falling back in item url: #{item_url}"
  #         doc = Nokogiri::HTML(self.class.scrape_content(item_url, 30.minute))
  #         permalink = doc.at_css('a:contains("Permanent link for this record")')

  #         # Item page doen't have a permalink? Must be a weird search result. Follow first View Full Record link and look for permalink there..
  #         if permalink.nil? && !(item_links = doc.css('.briefcitItems a:contains("View Full Record")')).empty?
  #           # puts "  parsing as: 2"
  #           item_url = "http://#{CATALOG_DOMAIN}#{item_links.first[:href]}" unless item_links.empty?
  #           # puts "!!! third fetch... #{item_url}"
  #           doc = Nokogiri::HTML(self.class.scrape_content(item_url, 30.minute))
  #           permalink = doc.at_css('a:contains("Permanent link for this record")')
  #         end
  #       end
  #     end

  #     if permalink.nil?
  #       puts "    BNUMBER NOT FOUND"

  #     elsif (p = permalink[:href].match(/record=(b[0-9]+)/)) && p.size == 2
  #       bnumber = p[1]
  #       ret = self.update :bnumber => bnumber
  #       # puts "    BNUMBER: #{self.bnumber} saved? #{self.persisted?} errors? #{self.errors.full_messages}"
  #     end

  #   end
  # end


  def update_availability
    available_copies = 0
    total_copies = 0

    if self.bnumber
      scrape_url = "http://#{CATALOG_DOMAIN}/search~S1?/.#{bnumber}/.#{bnumber}/1,1,1,B/holdings"
      content = self.class.scrape_content scrape_url, 30.minute

      doc = Nokogiri::HTML(content)
      puts "  Availability parsed from #{scrape_url}"
      doc.css('.bibItemsEntry').each do |availability_row|
        avail = availability_row.css('td').count { |td| td.text.strip.downcase.sub(/^\W+/,'') == 'available' } == 1

        total_copies += 1
        available_copies += 1 if avail
      end
    end

    # Update atts
    self.update({
      :available_copies => available_copies,
      :total_copies => total_copies
    })

    puts "Recalculating availability as \"#{self.availability}\" because #{self.available_copies} of #{self.total_copies} \
          avail with #{self.new_or_pending_holds.count} open holds"
    # Update availability status string
    self.recalculate_availability
  end

  # Called any time availability totals change due to newly scraped data or newly added holds
  # to update the availability string to 'Available' or 'All copies in use'
  def recalculate_availability
    copies = self.available_copies
    #Below code need to discuss with Darya.
    #copies -= self.new_or_pending_holds.count
    status = copies > 0 ? 'available' : 'unavailable'
    self.update_attribute :availability, status
  end


  # Probably old and unused.
  # Are you looking for the code that updates subjects when a teacher set is updated in Sierra,
  # and the bib record is sent to the MLN API?  Look at the update_subjects_via_api method.
  # def update_subjects
  #   subjects.clear

  #   # TODO: take the 1.day constant out into a properties file.
  #   # NOTE: the expiry was 1.day, changing to 8.hour to see fixes in human-administered time.
  #   links = self.class.scrape_css self.details_url, '.further_list a', 8.hour
  #   links.each do |n|
  #     next if n.text.include? 'Teacher Set'
  #     next if n.text.include? 'Adultery'

  #     title =n.text
  #     _t = '' + title
  #     # Truncate phrases like "Something something - some qualifying statement" to just "Something something":
  #     title = title.split(/( \W |\()/)[0]
  #     title = title.truncate 30
  #     title.strip!
  #     #puts "    Adding subject: #{title}#{title != _t ? " (orig \"#{_t}\")" : ''}"

  #     subject = Subject.find_or_create_by(title: title)
  #     # subject.teacher_sets << self unless subject.teacher_sets.include? self
  #     self.subjects << subject unless subject.teacher_sets.include? self
  #   end

  #   # Get primary subject from marc field 690
  #   subject = self.marc[690]
  #   unless subject.nil?
  #     subject = subject.sub /\.$/, ''
  #     # Strip off stupid (Teacher Set) qualifier cause I mean come on what the hell
  #     subject.sub! /\ \(Teacher Set\)/, ''

  #     # Determine popularity of subject
  #     subject_popularity = self.class.where(:area_of_study => subject).count
  #   end

  #   new_title = "" + self.title

  #   # puts "  Primary subj: #{subject}"
  #   # If primary subject is unpopular (e.g. Mythology, Libros en Espanol, Reading)
  #   if subject.nil? || subject_popularity < 10
  #     # puts "  ..Unpopular subject: #{subject} with #{subject_popularity} instances for title #{title}"

  #     # Look at popular primary_subjects and choose one that intersects with self.subjects
  #     self.class.group(:area_of_study).having('count(*) >= 10').count.each do |(label,count)|
  #       if self.has_subject label
  #         subject = label
  #       end
  #     end
  #     # Note that some unpopular primary_subjects (e.g. Math, Music) aren't overridden

  #     new_title.sub! /^#{Regexp.escape(subject)}: /, '' unless subject.nil?
  #   end

  #   self.update_attributes({
  #     :area_of_study => subject,
  #     :title => new_title
  #   })

  # end

  # Old and unused
  # def add_books_by_isbns(isbns)
  #   successes = 0
  #   puts "    Populating books by ISBNs: #{isbns}"
  #   isbns.each_with_index do |isbn, i|
  #     puts "    #{i+1}) #{isbn}:"
  #     cat_item = Book.catalog_item_by_query({:isbn => isbn}, true)
  #     if cat_item.nil?
  #       puts "    Couldn't find catalog item by isbn"

  #     else
  #       cat_item = Book.catalog_item(cat_item['id'])
  #       book = Book.upsert_from_catalog_item cat_item
  #       puts "     Adding book #{book.title}"
  #       self.teacher_set_books.push TeacherSetBook.create(:book => book, :teacher_set => self, :rank => i)

  #       successes += 1
  #     end
  #   end

  #   puts "  #{successes} of #{isbns.size} ISBNs resolved to catalog items"
  # end

  # Old and unused.
  # def update_books
  #   puts "  Update books for #{id}"
  #   scrape_url = "http://any.bibliocommons.com/item/catalogue_info/#{id}"

  #   # First try pulling books from marc record:
  #   # TODO: take the 1.day constant out into a properties file.
  #   rows = self.class.scrape_css scrape_url, '#marc_details tr', 1.day
  #   rows.each do |n|
  #     if (tag_col = n.at_css('td.marcTag')) && tag_col.text.strip == '944'
  #       isbns = n.at_css('td.marcTagData').text.sub(/^\$a/,'').strip.split ' '

  #       puts "  Adding books by marc 944 field"
  #       TeacherSetBook.destroy_for_set self.id
  #       self.add_books_by_isbns isbns

  #       self.update_attributes :set_type => isbns.size == 1 ? 'single' : 'multi'

  #       return
  #     end
  #   end


  #   # If that fails, try pulling it from biblio list via link in circ widget:
  #   scrape_url = "http://nypl.bibliocommons.com/item/show_circulation_widget/#{id}"
  #   data = self.class.scrape_content scrape_url, 14.day

  #   m = data.nil? ? nil : data.match(/<a [^>]*href=\\"([^\\]+)\\"[^>]*>List of Individual Titles/)

  #   if m.nil? || (list_url = m[1]).nil? || list_url.nil? || (list_id = list_url.match(/nypl_selection\/([0-9]+)/)).nil?
  #     puts "    Couldn't scrape list for #{id}"

  #   else
  #     list_id = list_id[1] unless list_id.nil?

  #     # list = api_call 'lists', list_id
  #     list = self.class.api_call "lists/#{list_id}"
  #     # puts "got list data: #{list.inspect}"

  #     TeacherSetBook.destroy_for_set self.id
  #     if list.nil? || list['list'].nil? || list['list']['list_items'].nil?
  #       puts "    No list items found for #{list_id}: #{list.inspect}"

  #     else
  #       puts "    Adding books by biblio list"
  #       list['list']['list_items'].each_with_index do |item, i|
  #         book = Book.update_by_catalog_id item['title']['id'].to_i
  #         puts "    Adding book #{i}: #{book.title}"
  #         self.teacher_set_books.push TeacherSetBook.create(:book => book, :teacher_set => self, :rank => i)
  #         # Book.upsert_from_catalog_item item
  #         # item = api_call 'titles', item['title']['id']
  #         # puts "got bigger item: #{item.inspect}"
  #         # b = save_book item['title']

  #       end

  #       self.update_attributes :set_type => list['list']['list_items'].size == 1 ? 'single' : 'multi'
  #     end
  #   end
  #   # self.save
  # end

  # Old and unused.
  #   def self.fetch_new(page=1, limit=25, just_id=nil)
  #     params = {:q => 'formatcode:(TEACHER_SETS )', :search_type => 'custom'}
  #     params[:limit] = limit
  #     puts "params: #{params.inspect}"
  #     params[:page] = page

  #     new = []
  #     unique_ids = []
  #     while (items = self.api_call("titles", params)) && !items['titles'].nil? && !items['titles'].empty?
  #       puts "______________________________________________________________"
  #       puts "API Fetch All: P #{params[:page]} of #{items['pages']}: #{items['titles'].count} items"

  #       items['titles'].each_with_index do |title, i|
  #         puts "#{(i+1) + (params[:page]-1)*params[:limit]} of #{items['count']}: Add/update #{title['id']}: #{title['title']}"
  #         id = title['id'].to_i
  #         # puts "upsert_from_catalog_id #{id}"
  #         new << id unless self.exists?(id)
  #         unique_ids << id

  #         # If debugging a specific id, skip all except for that id
  #         next if !just_id.nil? && id != just_id

  # =begin
  #         if self.exists? id
  #           s = self.find id
  #           next if !s.description.empty?
  #         end
  # =end
  #         set = upsert_from_catalog_id id
  #         # Comment out to get the list of teacher sets not in the app faster
  #         if !set.nil?
  #           set.update_availability
  #           set.update_books
  #           set.update_subjects
  #         end

  #       end

  #       params[:page] += 1
  #       # Reached the end?
  #       break if params[:page] > items['pages'].to_i
  #       # break if params[:page].to_i > 3
  #     end

  #     removed = self.where('id NOT IN (?)', unique_ids)

  #     puts "Double checking missing sets: #{removed.count}: #{removed.map {|s| s.id}.join ', '}"
  #     removed.each_with_index do |set, i|
  #       # puts "#{(i+1)} of #{removed.size}: Add/update #{set.id}: #{set.title}"

  #       if !(resp = self.api_call("titles/#{set.id}")).nil? && !resp.keys.include?('error')
  #         # puts "#{resp['title']['availability']['id']}"

  #         # Bibliocommons now returns a valid json response even if the set/book
  #         # is deleted. Check if the availability is 'deleted'.
  #         if resp['title']['availability']['id'] == 'DELETED'
  #           puts "#{resp['title']['id']}, #{resp['title']['title']}, #{resp['title']['details_url']}, #{resp['title']['call_number']}"
  #         end

  #         set = upsert_from_catalog_id set.id
  #         if !set.nil?
  #           set.update_availability
  #           set.update_books
  #           set.update_subjects
  #         end

  #       else
  #         puts "DELETE THIS SET (maybe): #{set.id} doesn't resolve at the api anymore..."
  #       end

  #     end
  #     # puts "Removed: #{removed.count}: #{removed.map {|s| s.id}.join ', '}"

  #     puts "New: #{new.size}: #{new.join ', '}"
  #     puts "Done"

  # end


  # Save teacher-set set_type value
  def update_teacher_set_set_type_value(set_type_val)
    set_type = update_set_type(set_type_val)
    LogWrapper.log('INFO', {'message' => "Teacher set set_type value: #{set_type} saved in DB", 
                            'method' => 'teacher_set.update_teacher_set_set_type_value'})
  rescue StandardError => e
    raise DBException.new(TEACHERSET_SETTYPE_ERROR[:code], TEACHERSET_SETTYPE_ERROR[:msg])
  end

  def update_set_type(set_type_val)
    begin
      set_type = derive_set_type(set_type_val)
      update(set_type: set_type)
    rescue StandardError => e
      LogWrapper.log('ERROR', {'message' => "Error occcured while updating the set_type value: #{set_type}",
                               'method' => 'teacher_set.update_set_type'})

      raise DBException.new(TEACHERSET_SETTYPE_ERROR[:code],TEACHERSET_SETTYPE_ERROR[:msg])
    end
    set_type
  end

  # Set type value varFields entry with the marcTag=526
  # case 1: {:fieldTag=>"n", :marcTag=>"526", :ind1=>"0", :ind2=>"", :content=>"null", :subfields=>[{:tag=>"a", :content=>"Topic Set"}]}
  # If subfields.content type is "Topic Set", set_type value  stored as 'multi' in teacher_sets table.
  # If subfields.content type is "Book Club Set" set_type value  stored as 'single' in teacher_sets table.
  # case 2: If it is not present in subfields.content, derive the set_type from the number of distinct books attached to a TeacherSet.
  # If teacher-set-books exactly 1, it's a Bookclub Set; else it's a Topic Set.
  def derive_set_type(set_type_field)
    set_type = set_type_field
    return set_type.strip().gsub(/\.$/, '').titleize if set_type.present?
    
    if self.books.count.to_i > 1
      return TOPIC_SET
    elsif self.books.count.to_i == 1
      return BOOK_CLUB_SET
    end
  end
  
  # Update teacher sets set-type nil to value from sierra
  def update_set_type_from_nil_to_value
    teacher_sets = TeacherSet.where(set_type: nil)
    teacher_sets.each do |teacher_set|
      bib_id = teacher_set.bnumber.split('b')[1]
      next if bib_id.nil?

      LogWrapper.log('DEBUG', {'message' => "Teacher set bib-id value: #{bib_id}", 'method' => 'teacher_set.update_set_type_from_nil_to_value'})
      set_type = teacher_set.get_set_type_value_from_bib_response(bib_id)
      teacher_set.update_set_type(set_type)
    end
  end
  
  # Receive JSON related to a teacher_set.
  # For each ISBN, ensure there is an associated book.
  # Disassociate books that are no longer in the teacher set.
  def update_included_book_list(teacher_set_record)
    # Gather all ISBNs.
    return unless teacher_set_record['varFields']

    isbns = []
    teacher_set_record['varFields'].each do |var_field|
      next unless var_field['marcTag'] == '944'
      next unless var_field['subfields'] && var_field['subfields'][0] && var_field['subfields'][0]['content']

      isbns = var_field['subfields'][0]['content'].split
    end

    # Delete teacher_set_books records for books with an ISBN that is not in the teacher_set's list of ISBNs.
    return if isbns.empty?

    self.teacher_set_books.each do |teacher_set_book|
      if !teacher_set_book.book || (teacher_set_book.book.isbn.present? && !isbns.include?(teacher_set_book.book.isbn))
        teacher_set_book.destroy
      end
    end

    # Create a book if one does not yet exist for that ISBN.
    # Associate the book to the teacher set by creating a TeacherSetBook record if one does not yet exist.
    # Update all books in the teacher set.
    isbns.each do |isbn|
      book = Book.find_by_isbn(isbn) || Book.create(isbn: isbn)
      TeacherSetBook.where(teacher_set_id: self.id, book_id: book.id).first_or_create
      book.update_from_isbn
    end
  end

  # This is called from the bibs_controller.
  # Delete all records for a teacher set in the join table SubjectTeacherSet, then
  # create new records (and subjects if they do not exist) in that join table.
  def update_subjects_via_api(subject_name_array)
    return if subject_name_array.blank?

    # record the list of current teacher set <--> subject associations,
    # so we can prune the subjects later.
    old_subjects = Array.new

    self.subjects.each do |subject|
      old_subjects.push(subject.id)
    end

    # delete the current teacher set <--> subject associations,
    # so we can remake them fresh from the bib info.
    self.subjects.clear

    # Create all the subjects and teacher_set <--> subject associations specified in the bib
    # record we're processing, ignoring duplicate associations.
    subject_name_array.each do |subject_name|
      subject_name = clean_subject_string(subject_name)
      subject = Subject.find_or_create_by(title: subject_name)
      subject_teacher_set = SubjectTeacherSet.find_or_create_by(teacher_set_id: self.id, subject_id: subject.id)
    end
    prune_subjects(old_subjects)
    self.subjects.reload
  end

  # Clean up the area_of_study field to match the subjects table title string rules.
  # We do this, because there's some filtering that goes on, matching the teacher_set.area_of_study
  # to the subjects.title, and we want to make sure the string follow some conventions.
  def clean_primary_subject()
    self.area_of_study = self.clean_subject_string(self.area_of_study)
    self.save
  end

  # Any text massaging, such as constraining word length,
  # trimming, etc. go here.
  def clean_subject_string(old_subject_string)
    return if old_subject_string.blank?

    # There's a max of 30 characters in the database
    new_subject_string = old_subject_string.strip[0..29]

    # strip leading and trailing whitespace
    new_subject_string = new_subject_string.strip()

    # Check if "NYC" is present
    if KEY_WORDS.any? { |keyword| new_subject_string.include?(keyword) }
      # Remove any trailing period
      new_subject_string = new_subject_string.gsub(/\.$/, '')

      # Split the string into words
      parts = new_subject_string.split

      # Titleize every word except for those in the keywords array
      parts.map! do |word|
        KEY_WORDS.include?(word) ? word : word.titleize
      end

      # Join the parts back into a single string
      new_subject_string = parts.join(' ')
    else
      new_subject_string = new_subject_string.gsub(/\.$/, '').titleize
    end
    # If new_subject_string is empty, return nil, else return new_subject_string.
    return unless new_subject_string.present?

    return new_subject_string 
  end
  
  # Delete old subjects that do not have any records in the join table,
  # because they are not associated with any teacher sets.
  def prune_subjects(subject_id_array)
    subject_id_array.each do |subject_id|
      found_subject = Subject.find(subject_id)
      if (found_subject and SubjectTeacherSet.where(subject_id: subject_id).empty?)
        found_subject.destroy
      end
    end
  end
  
  # This is called from the bibs_controller.
  # Delete all records for a teacher set in the table TeacherSetNotes, then
  # create new records in that table.
  def update_notes(teacher_set_notes_string)
    TeacherSetNote.where(teacher_set_id: self.id).destroy_all
    return if teacher_set_notes_string.blank?

    teacher_set_notes_string.split(',').each do |note_content|
      TeacherSetNote.create(teacher_set_id: self.id, content: note_content)
    end
  rescue StandardError => e
    raise TeacherSetNoteException.new(TEACHER_SET_NOTE_EXCEPTION[:code], TEACHER_SET_NOTE_EXCEPTION[:msg])
  end
  
  # Calls Bib service for items.
  # Parses out the items duedate, items code is '-' which determines if an item is available or not.
  # Calculates the total number of items and available items in the list
  # Updated MLN DB with Total copies and available copies.
  def update_available_and_total_count(bibid)
    response = get_items_info_from_bibs_service(bibid)
    self.update(total_copies: response[:total_count], available_copies: response[:available_count],
                availability: response[:availability_string])
    update_teacher_set_availability_in_elastic_search
    return {bibs_resp: response[:bibs_resp]}
  end
  
  # Calls Bib service for items.
  def get_items_info_from_bibs_service(bibid)
    bibs_resp, items_found = send_request_to_items_microservice(bibid)
    return {bibs_resp: bibs_resp} if !items_found

    total_count, available_count = parse_items_available_and_total_count(bibs_resp)
    availability_string = (available_count.to_i > 0) ? AVAILABLE : UNAVAILABLE
    return {bibs_resp: bibs_resp, total_count: total_count, available_count: available_count, availability_string: availability_string}
  end
  
  # Parses out the items duedate, items code is '-' which determines if an item is available or not.
  # Calculates the total number of items in the list, the number of items that are
  # available to lend.
  def parse_items_available_and_total_count(response)
    available_count = 0
    total_count = 0
    item_status_codes = ['w', 'm', 'k', 'u']
    response['data'].each do |item|
      total_count += 1 unless (item['status']['code'].present? && item_status_codes.include?(item['status']['code']))
      available_count += 1 if (item['status']['code'].present? && item['status']['code'] == '-') && (!item['status']['duedate'].present?)
    end
    LogWrapper.log('INFO','message' => "TeacherSet available_count: #{available_count}, total_count: #{total_count}")
    return total_count, available_count
  end

  # Call sierra bib api to get set_type value
  def get_set_type_value_from_bib_response(bibid)
    resp = send_request_to_bibs_microservice(bibid)
    set_type = nil
    if resp.present? && resp.code == 200
      resp["data"].each do |bib_record|
        set_type_marctag = bib_record['varFields'].detect { |hash| hash['marcTag'] == '526' }
        if set_type_marctag.present?
          set_type = set_type_marctag['subfields'].map { |x| x['content']}.join(', ')
        end
      end
    end
    set_type
  end


  private

  #Sends a request to the items microservice.
  #Calling items service api by pagination, fetching 25 items by each call pushing into array.
  #If its getting less than 25 items by items service call, we are not calling again.
  def send_request_to_items_microservice(bibid,offset=nil,response=nil,items_hash={})
    limit = 25
    offset = offset.nil? ? 0 : offset += 1
    request_offset = limit.to_i * offset.to_i
    items_found = response && (response.code == 200 || items_hash['data'].present?)

    if response && (response.code != 200 || (items_hash['data'].present? && response['data'].size.to_i < limit))
      return items_hash, items_found
    else
      items_query_params = "?bibId=#{bibid}&limit=#{limit}&offset=#{request_offset}"
      response = HTTParty.get(ENV.fetch('ITEMS_MICROSERVICE_URL_V01', nil) + items_query_params, headers: { 
        'authorization' => "Bearer #{Oauth.get_oauth_token}", 'Content-Type' => 'application/json' }, timeout: 10)
      
      if response.code == 200 || items_hash['data'].present?
        resp = (ENV['RAILS_ENV'] == 'test')? JSON.parse(response) : response
        items_hash['data'] ||= []
        items_hash['data'] << resp['data'] if resp['data'].present?
        items_hash['data'].flatten!
        LogWrapper.log('DEBUG', {
          'message' => "Response from item services api",
          'method' => 'send_request_to_items_microservice',
          'status' => response.code,
          'responseData' => response.message
        })
      elsif response.code == 404
        items_hash = response
        LogWrapper.log('DEBUG', {
          'message' => "The items service could not find the Items with bibid=#{bibid}",
          'method' => 'send_request_to_items_microservice',
          'status' => response.code
        })
      else
        LogWrapper.log('ERROR', {
          'message' => "An error has occured when sending a request to the bibs service bibid=#{bibid}",
          'method' => 'send_request_to_items_microservice',
          'status' => response.code
        })
      end
    end

    #Recursive call
    send(__method__, bibid, offset, response, items_hash)
  end

  # Sends a request to the bibs microservice.(Get bib response by bibid)
  # Sierra-bib-response-by-bibid-url: "{BIBS_MICROSERVICE_URL_V01}/nyplSource=#{SIERRA_NYPL}&id=#{bibid}"
  def send_request_to_bibs_microservice(bibid)
    bib_query_params = "?nyplSource=#{SIERRA_NYPL}&id=#{bibid}"
    response = HTTParty.get(
      ENV.fetch('BIBS_MICROSERVICE_URL_V01', nil) + bib_query_params, 
      headers: { 'Authorization' => "Bearer #{Oauth.get_oauth_token}",'Content-Type' => 'application/json' }, 
      timeout: 10
    )

    if response.code == 200
      LogWrapper.log('DEBUG', {
        'message' => "Response from bib services api",
        'method' => 'send_request_to_bibs_microservice',
        'status' => response.code,
        'responseData' => response.message
      })
    elsif response.code == 404
      items_hash = response
      LogWrapper.log('DEBUG', {
        'message' => "The bib service could not find with bibid=#{bibid}",
        'method' => 'send_request_to_bibs_microservice',
        'status' => response.code
      })
    else
      LogWrapper.log('ERROR', {
        'message' => "An error has occured when sending a request to the bibs service bibid=#{bibid}",
        'method' => 'send_request_to_bibs_microservice',
        'status' => response.code
      })
    end
    response
  end
end
