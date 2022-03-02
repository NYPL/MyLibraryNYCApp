# frozen_string_literal: true

module CatalogItemMethods
  CATALOG_DOMAIN = 'ilsstaff.nypl.org:2082'

  BIBLIO_API_RETRIES = 3      # Retry failed biblio api queries
  BIBLIO_API_RETRY_WAIT = 5   # Sleep this many seconds between failed api queries

  # CATALOG_DOMAIN = 'catalog.nypl.org'

  def disable_papertrail
    # If we don't turn off papertrail here, then a new version is created when a book is created by getting added to a teacher set.
    # To be consistent with teacher sets, we are not creating versions when an object is created.
    # We don't create versions for initially created objects, because there are existing objects in the db that did not get their initial version.
    PaperTrail.enabled = false
    return true
  end

  def enable_papertrail
    # We always want new versions for updated books and teacher_sets, so we enable PaperTrail here.
    # before_update happens after before_save so it overrides the disabling that happens in before_save.
    # Source: https://guides.rubyonrails.org/active_record_callbacks.html
    PaperTrail.enabled = true
  end

  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def suitabilities
      ret = []
      unless grade_begin.nil?
        g_begin = grade_begin
        if grade_end.nil?
          grade_begin = g_begin == TeacherSet::PRE_K_VAL ? 'Pre-K' : g_begin == TeacherSet::K_VAL ? 'K' : g_begin
          ret << "Grade #{grade_begin}+"
        else
          g_end = grade_end
          grade_begin = g_begin == TeacherSet::PRE_K_VAL ? 'Pre-K' : g_begin == TeacherSet::K_VAL ? 'K' : g_begin
          grade_end = g_end == TeacherSet::PRE_K_VAL ? 'Pre-K' : g_end == TeacherSet::K_VAL ? 'K' : g_end
          ret << "Grades #{grade_begin}  to  #{grade_end}"
        end
      end
      unless lexile_begin.nil? or true # removing lexiles
        if lexile_end.nil?
          ret << "#{lexile_begin}+"
        else
          ret << "L#{lexile_begin} - L#{lexile_end}"
        end
      end
      ret
    end

    # Grades = {Pre-K => -1, K => 0}
    def grade_val(grade)
      return 'Pre-K' if grade == TeacherSet::PRE_K_VAL

      return 'K' if grade == TeacherSet::K_VAL

      return grade
    end

    # Unused code
    # def marc
    #   ret = {}

    #   scrape_url = "http://nypl.bibliocommons.com/item/catalogue_info/#{id}"
    #   rows = self.class.scrape_css scrape_url, '#marc_details tr', 1.day
    #   rows.each do |n|
    #     if (tag_col = n.at_css('td.marcTag')) && (key = tag_col.text.strip).match(/^[0-9]+$/)
    #       val = n.at_css('td.marcTagData').text.strip
    #       # Remove leading and trailing ctrl codes (e.g. "$aEnglish Language Arts.$2local")
    #       val.sub! /^\$a/,''
    #       val.sub! /\$[0-9a-z]+$/,''
    #       val.strip!
    #       ret[key.to_i] = val
    #     end
    #   end
    #   # puts "marc: #{ret.inspect}"

    #   ret
    # end

    # def update_bnumber!
    #   if self.details_url && self&.details_url&.include?('record=')
    #     self.bnumber = self.details_url.split('record=')[1].split('~')[0]
    #     self.save
    #   elsif self.details_url && self&.details_url&.include?('bibliocommons.com/item/show/') && self.details_url[-2..-1] == '052'
    #     self.bnumber = self.details_url.split('bibliocommons.com/item/show/')[1].gsub('052', '')
    #     self.save
    #   end
    # end
  end

  module ClassMethods
    # old and unused
    # def api_call(endpoint, params={}, kill_cache=false, retries=0)
    #   p = {}


    #   url = 'https://api.bibliocommons.com/v1'
    #   url += "/#{endpoint}"

    #   p[:date_format] = 'iso8601'
    #   p[:locale] = 'en-US'
    #   p[:library] = 'nypl'
    #   p[:api_key] = ENV['BIBLIO_KEY']
    #   if ENV['BIBLIO_KEY'].nil?
    #     puts "Need to set ENVs"
    #     exit
    #   end
    #   p = p.merge(params)

    #   # puts "    [API params: #{p.inspect}]"

    #   key = endpoint + '?' + params.to_s

    #   Rails.cache.delete(key) if kill_cache
    #   resp = Rails.cache.fetch(key, :expires_in => 1.day) do
    #     query_string = p.map{ |x,v| "#{x}=#{v}" }.join('&')
    #     puts "    API: #{url} ? #{params.to_s} ( #{query_string})"
    #     begin
    #       resp = HTTParty.get(url, :query=>p)
    #       sleep 0.51
    #       objs = JSON.parse resp.to_json
    #     rescue
    #       puts "WARN: Error parsing JSON from biblio api"
    #       objs = {"error" => "true"}
    #     end
    #   end

    #   # resp = {"error" => "true"} if rand < 0.30

    #   # Error response?
    #   if resp.nil? || resp.to_s.size < 35 || resp.keys.include?('error')
    #     Rails.cache.delete(key)

    #     # Don't retry indefinitely
    #     if retries < BIBLIO_API_RETRIES

    #       puts "WARNING: BIBLIO API FAILED (/#{endpoint}) #{retries + 1} time(s). Waiting #{BIBLIO_API_RETRY_WAIT}s to retry"
    #       sleep BIBLIO_API_RETRY_WAIT

    #       # Retry call:
    #       resp = api_call endpoint, params, kill_cache, retries + 1

    #     else
    #       puts "FAIL: API failed to fetch /#{endpoint}?#{p.to_s} after #{BIBLIO_API_RETRIES} retries"
    #     end
    #   end
    #   # puts " resp: #{resp.to_s.size}"

    #   resp
    # end

    # def scrape_content(url, expires=1.hour, sleep=0.51)
    #   key = Digest::MD5.hexdigest url

    #   Rails.cache.fetch(key, :expires_in => expires) do
    #     require 'open-uri'
    #     # puts "    [scrape cache miss: #{url}]" #  (#{key} exp #{expires})]"
    #     content = nil
    #     begin
    #       open(url, :allow_redirections => :safe) { |io| content = io.read }
    #     rescue Exception => e
    #       puts "  ERROR fetching #{url}: #{e}"
    #     end
    #     sleep sleep
    #     content
    #   end
    # end

    # def scrape_css(url, css, expires=1.hour)
    #   content = self.scrape_content url, expires
    #   doc = Nokogiri::HTML(content)
    #   doc.css(css)
    # end
  end
end
