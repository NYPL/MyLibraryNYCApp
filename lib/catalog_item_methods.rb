module CatalogItemMethods

  CATALOG_DOMAIN = 'ilsstaff.nypl.org:2082'

  BIBLIO_API_RETRIES = 3      # Retry failed biblio api queries
  BIBLIO_API_RETRY_WAIT = 5   # Sleep this many seconds between failed api queries

  # CATALOG_DOMAIN = 'catalog.nypl.org'

  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def suitabilities
      ret = []
      unless grade_begin.nil?
        if grade_end.nil? || grade_end == 0
          ret << "Grade #{grade_begin}+"
        else
          ret << "Grades #{grade_begin} - #{grade_end}"
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

    def marc
      ret = {}

      scrape_url = "http://nypl.bibliocommons.com/item/catalogue_info/#{id}"
      rows = self.class.scrape_css scrape_url, '#marc_details tr', 1.day
      rows.each do |n|
        if (tag_col = n.at_css('td.marcTag')) && (key = tag_col.text.strip).match(/^[0-9]+$/)
          val = n.at_css('td.marcTagData').text.strip
          # Remove leading and trailing ctrl codes (e.g. "$aEnglish Language Arts.$2local")
          val.sub! /^\$a/,''
          val.sub! /\$[0-9a-z]+$/,''
          val.strip!
          ret[key.to_i] = val
        end
      end
      # puts "marc: #{ret.inspect}"

      ret
    end
  end

  module ClassMethods

    def api_call(endpoint, params={}, kill_cache=false, retries=0)
      p = {}
      

      url = 'https://api.bibliocommons.com/v1'
      url += "/#{endpoint}"

      p[:date_format] = 'iso8601'
      p[:locale] = 'en-US'
      p[:library] = 'nypl'
      p[:api_key] = ENV['BIBLIO_KEY']
      if ENV['BIBLIO_KEY'].nil?
        puts "Need to set ENVs"
        exit
      end
      p = p.merge(params)

      # puts "    [API params: #{p.inspect}]"

      key = endpoint + '?' + params.to_s

      Rails.cache.delete(key) if kill_cache
      resp = Rails.cache.fetch(key, :expires_in => 1.day) do
        query_string = p.map{ |x,v| "#{x}=#{v}" }.join('&')
        puts "    API: #{url} ? #{params.to_s} ( #{query_string})"
        begin
          resp = HTTParty.get(url, :query=>p)
          sleep 0.51
          objs = JSON.parse resp.to_json
        rescue
          puts "WARN: Error parsing JSON from biblio api"
          objs = {"error" => "true"}
        end
      end

      # resp = {"error" => "true"} if rand < 0.30

      # Error response?
      if resp.nil? || resp.to_s.size < 35 || resp.keys.include?('error')
        Rails.cache.delete(key) 

        # Don't retry indefinitely
        if retries < BIBLIO_API_RETRIES
          
          puts "WARNING: BIBLIO API FAILED (/#{endpoint}) #{retries + 1} time(s). Waiting #{BIBLIO_API_RETRY_WAIT}s to retry"
          sleep BIBLIO_API_RETRY_WAIT

          # Retry call:
          resp = api_call endpoint, params, kill_cache, retries + 1

        else
          puts "FAIL: API failed to fetch /#{endpoint}?#{p.to_s} after #{BIBLIO_API_RETRIES} retries"
        end
      end
      # puts " resp: #{resp.to_s.size}"

      resp
    end

    def scrape_content(url, expires=1.hour, sleep=0.51)
      key = Digest::MD5.hexdigest url

      Rails.cache.fetch(key, :expires_in => expires) do
        require 'open-uri'
        # puts "    [scrape cache miss: #{url}]" #  (#{key} exp #{expires})]"
        content = nil
        begin
          open(url, :allow_redirections => :safe) { |io| content = io.read }
        rescue Exception => e
          puts "  ERROR fetching #{url}: #{e}"
        end
        sleep sleep
        content
      end
    end

    def scrape_css(url, css, expires=1.hour)
      content = self.scrape_content url, expires
      doc = Nokogiri::HTML(content)
      doc.css(css)
    end
  end

end
