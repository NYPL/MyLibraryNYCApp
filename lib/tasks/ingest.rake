# frozen_string_literal: true

require 'net/http'
require 'uri'

require 'csv'

namespace :ingest do

  # Fetch latest data from biblio
  desc "Import new data"
  task :ingest, [:page, :limit, :just_id] => :environment do |t, args|
    args.with_defaults(:page=> 1, :limit => 25, :just_id => nil)

    page = args.page.to_i
    page = 1 if page == 0

    limit = args.limit.to_i
    limit = 25 if limit == 0

    just_id = args.just_id.to_i
    just_id = nil if just_id == 0

    TeacherSet.fetch_new page, limit, just_id
  end

  # Update availability status and counts of all sets by scraping internal catalog
  desc "Update availability numbers for all sets"
  task :update_availability, [:start, :limit, :id] => :environment do |t, args|
    args.with_defaults(:start => 0, :limit => nil, :id => nil)
    start = args.start.to_i
    limit = args.limit.to_i unless args.limit.nil?
    id = args.id

    sets = TeacherSet
    sets = sets.limit limit unless limit.nil?
    sets = sets.offset start unless start.nil?
    sets = sets.order('id ASC')
    sets = [sets.find(id)] unless id.nil?
    sets.each_with_index do |set, i|
      puts "#{i}: #{set.id}: #{set.title}"
      set.update_availability
    end
  end

  # Created because some sets appear in the app but not in Sierra.
  # Bibliocommons API now returns a response, even if the teacher set
  # is no longer available.
  desc "Remove teacher sets based on call number"
  task :remove_teacher_sets, [] => :environment do |t, args|
    require 'csv'

    path = 'db/data_update_dec2014/Dec15.2014-TeacherSetsToRemoveWebApp.csv' # TODO: remove hardcoding

    teacher_sets_not_found = []

    CSV.foreach(path) do |line|
      (call_number, set_title) = line

      # puts "#{call_number}"

      teacherSet = TeacherSet.find_by_call_number call_number.strip

      if teacherSet.nil?
        puts "    Teacher Set not found: #{call_number}"
        teacher_sets_not_found << "#{call_number}"
      else
        puts "Deleting Teacher Set: #{call_number}"
        teacherSet.destroy
      end
    end

    puts "Total number of sets not found: #{teacher_sets_not_found.size}"
  end


  # Updated for December 1st, 2014 release.
  desc "Import all teacher data from local csvs into users table"
  task :teachers, [] => :environment do |t, args|
    require 'csv'

    path = 'db/data_update_dec2014/Amie edits data phone app - Main Data.csv' # TODO: remove hardcoding
    create_users = []
    distinct_emails = []
    duplicate_emails = []
    update_users = []

    CSV.foreach(path) do |line|
      # Example,Aliza,23333000000000,'example@example.com',zm047,47 Example School
      (last_name, first_name, barcode, email, school_code, school_name) = line

      next if email.nil? || email.strip.empty?

      puts "#{email}"

      if (school = School.find_by_code(school_code.strip.downcase)).nil?
        puts "school not found '#{school_code}'"
      elsif school.active?
        user = User.find_by_email email.downcase
        if user.nil?

          if distinct_emails.include? email
            duplicate_emails << email
            alt_barcode = create_users.find {|user| user[:email] == email}[:barcode]
            create_users.delete_if {|user| user[:email] == email}

            duplicate_barcode = "#{barcode};#{alt_barcode}"

            puts "Duplicate email for new user: #{email}, updating alt_barcode"
            create_users << {email: email.strip, name: "#{last_name}, #{first_name}", barcode: duplicate_barcode.strip, 
school_code: school_code.strip, school: school}
          else
            distinct_emails << email
            puts "Couldn't find user: #{email} [#{line}]"
            create_users << {email: email.strip, name: "#{last_name}, #{first_name}", barcode: barcode.strip, school_code: school_code.strip, 
school: school}
          end

        else
          update_users << "#{email}"
          puts "Updating existing user: #{email}"

          alt_barcodes = nil
          if user.barcode != barcode.to_i
            # Update alt_barcodes
            if user.alt_barcodes.nil?
              alt_barcodes = "#{user.barcode}"
            else
              alt_barcodes = "#{user.alt_barcodes};#{user.barcode}"
            end
            puts "barcode: #{barcode}, alt: #{alt_barcodes}"
          end

          user.home_library = school_code.strip.downcase
          user.update({
            :first_name => first_name,
            :last_name => last_name,
            :barcode => barcode.to_i,
            :alt_barcodes => alt_barcodes
          })

          user.save
        end

        # Find the user by email
      end
    end

    # Don't touch these records: select id, email, school_id FROM users where updated_at > '2014-02-7' OR email ILIKE '@nypl.org' OR
    # id in (SELECT user_id FROM holds);
    delete = User.where("id NOT IN (SELECT user_id FROM holds) AND email NOT ILIKE '%nypl.org' AND updated_at <= '2014-02-7'")
    puts "Create #{create_users.size} users"
    puts "Update #{update_users.size} users"
    puts "Delete #{delete.count} users"

    create_users.each_with_index do |u, i|
      email = u[:email]
      name = u[:name]
      barcode = u[:barcode]
      home_library = u[:school_code]

      if (names = name.split(';')).size >= 2
        name = names.find {|n| !n.index(',').nil? }
        puts " mult names: #{names.size}: #{names.select {|n| !n.index(',').nil? }}"
        name = names.first if name.nil?
      end

      puts "Processing #{i}: #{name}"

      (last_name, first_name) = name.split ', '
      first_name = '' if first_name.nil?
      last_name.capitalize!
      first_name.capitalize!

      alt_barcodes = nil
      if (barcodes = barcode.split(';')).size >= 2
        puts " mult barcodes: #{barcodes.size}"
        barcode = barcodes.shift
        alt_barcodes = barcodes.join ', '
        puts "  Adding alt barcode: #{alt_barcodes}"
      end
      barcode = barcode.to_i
      email.downcase!

      # If two emails given, e.g.:
      # e.g. "...867"|"zx080"|"MYEXAMPLE@SCHOOLS.NYC.GOV";"MyExample@schools.nyc.gov"
      # .. save one email as alternate
      alt_email = nil
      if (emails = email.split(';')).size >= 2
        email = emails[0]
        alt_email = emails[1] unless email == emails[1]
      end

      user = User.find_or_initialize_by_email(email.downcase)
      user.home_library = home_library
      user.update({
        :first_name => first_name,
        :last_name => last_name,
        :barcode => barcode,
        :alt_barcodes => alt_barcodes
      })

      user.school = u[:school]
      puts " user has custom school: #{user.school}" if user.school != u[:school]
      user.update_attribute :alt_email, alt_email unless alt_email.nil? or !user.alt_email.empty?

      user.save
      puts "save user: #{email} exists ? #{user.persisted?}" if !user.persisted?

      # All validation failures so far seen have been due to "null" email in csvs
      if user.errors.count > 0
        puts "Errors: #{user.errors.full_messages}"
        puts "  row: #{i} #{u.inspect}"
      end
    end
  end

  desc "Remove teachers from database based on cvs file"
  task :remove_teachers, [] => :environment do |t, args|
    require 'csv'

    path = 'db/data_update_dec2014/Dec4.2014-DroppedEducators.csv' # TODO: remove hardcoding
    deleted_users = []
    not_found_users = []
    no_emails = []

    CSV.foreach(path) do |line|
      # ACOSTA,ANA,27777000000000,example@schools.nyc.gov,zk053,P.S. K053
      (last_name, first_name, barcode, email, school_code, school_name) = line

      if email.nil? || email.strip.empty?
        no_emails << "#{last_name}, #{first_name}"
        next
      end

      user = User.find_by_email email.strip.downcase
      if user.nil?
        puts "Could not find user: #{email}"
        not_found_users << "#{email}"
      else
        puts "Will delete educator: #{email}"
        deleted_users << "#{email}"
        user.destroy
      end
    end

    puts "Users not found to delete, #{not_found_users.size}: #{not_found_users}"
    puts "Deleted a total of #{deleted_users.size} users from the database"
    puts "Users with no emails, #{no_emails.size}: #{no_emails}"
  end

  # This use to be the :teachers task but it has been updated due to new
  # data set structure.
  desc "Import all teacher data from local csvs into users table"
  task :deprecated_teachers, [] => :environment do |t, args|
    require 'csv'

    dumps_base = 'db/final-schools-dump'

    create_users = []

    School.active.each do |school|
      code = school.code
      path = "#{dumps_base}/#{code}.csv"
      path = "#{dumps_base}/e#{code}.csv" if !File.exist?(path)

      if File.exists?(path)
        puts "Process teachers for #{code}"
        CSV.foreach(path) do |line|
          # "p44607908",151,"KIM, DENISE",23333087938609,"zx445",9/27/2013,0,2,9/14/2011,"example@myschool.edu"
          (_number, _type, name, barcode, school_code, _n1, _n2, _d1, _d2, email) = line
          next if email.nil? || email.strip.empty?

          user = User.find_by_email email.downcase
          if user.nil?
            puts "couldn't find user: #{email} [#{line}]"
          end

          create_users << {email: email.strip, name: name.strip, barcode: barcode.strip, school_code: school_code.strip, school: school}

        end

      else
        puts "Missing teachers dump for #{code} (#{path})"
      end
    end

    # Don't touch these records: select id, email, school_id FROM users where updated_at > '2014-02-7' OR email ILIKE '@nypl.org' OR id in 
    # (SELECT user_id FROM holds);
    delete = User.where("id NOT IN (SELECT user_id FROM holds) AND email NOT ILIKE '%nypl.org' AND updated_at <= '2014-02-7'")
    puts "Create #{create_users.size} users"
    puts "Delete #{delete.count} users"

    add_emails = create_users.map { |u| u[:email].downcase }
    User.where("id IN (SELECT user_id FROM holds) OR updated_at > '2014-02-7'").each do |u|
      if ! add_emails.include? u.email.downcase
        puts " Keeping #{u.email} but why"
      end
    end

    create_users.each_with_index do |u, i|
      email = u[:email]
      name = u[:name]
      barcode = u[:barcode]
      home_library = u[:school_code]

      if (names = name.split(';')).size >= 2
        name = names.find {|n| !n.index(',').nil? }
        puts " mult names: #{names.size}: #{names.select {|n| !n.index(',').nil? }}"
        name = names.first if name.nil?
      end

      puts "Processing #{i}: #{name}"

      (last_name, first_name) = name.split ', '
      first_name = '' if first_name.nil?
      last_name.capitalize!
      first_name.capitalize!

      alt_barcodes = nil
      if (barcodes = barcode.split(';')).size >= 2
        puts " mult barcodes: #{barcodes.size}"
        barcode = barcodes.shift
        alt_barcodes = barcodes.join ', '
        puts "  Adding alt barcode: #{alt_barcodes}"
      end
      barcode = barcode.to_i
      email.downcase!

      # If two emails given, e.g.:
      # e.g. "...867"|"zx080"|"MYEXAMPLE@SCHOOLS.NYC.GOV";"MyExample@schools.nyc.gov"
      # .. save one email as alternate
      alt_email = nil
      if (emails = email.split(';')).size >= 2
        email = emails[0]
        alt_email = emails[1] unless email == emails[1]
      end

      user = User.find_or_initialize_by_email(email.downcase)
      user.update({
        :first_name => first_name,
        :last_name => last_name,
        :home_library => home_library,
        :barcode => barcode,
        :alt_barcodes => alt_barcodes
      })

      user.school = u[:school]
      puts " user has custom school: #{user.school}" if user.school != u[:school]
      # user.update_attribute :alt_email, alt_email unless !user.alt_email.empty? or alt_email.nil?

      # user.save
      puts "save user: #{email} exists ? #{user.persisted?}" if !user.persisted?

      # All validation failures so far seen have been due to "null" email in csvs
      if user.errors.count > 0
        puts "Errors: #{user.errors.full_messages}"
        puts "  row: #{i} #{u.inspect}"
      end
    end

  end

  task :backup do
    sh 'rake db:data:dump_dir dir="backups/`date +"%Y%m%d"`"'
  end

  desc "Add and update list of participating schools"
  task :update_schools, [] => :environment do |t, args|
    path = 'db/2016-october-update/participating_school_list-2016-2017.csv' # TODO: remove hardcoding

    CSV.foreach(path) do |line|
      (code, name) = line
      puts "#{code} - #{name}"
      if (school = School.find_by_code("z#{code}".downcase)).nil?
        puts "Adding new school, code: #{code}"
        puts "  #{name}"
        new_school = School.find_or_create_by_name name
        new_school.code = "z#{code}".downcase
        new_school.active = true
        new_school.save
      else
        if school.name.strip.downcase != name.strip.downcase
          puts "Updating school name:"
          puts "  existing:   #{school.name}"
          puts "  referenced: #{name}"
          school.name = name
        end

        school.active = true
        school.save
      end
    end
  end

  # This rake task will import new schools and override values for existing schools
  # Example: `rake ingest:import_all_nyc_schools['data/public/2016_-_2017_School_Locations.csv', false]`
  # The second argument is for whether the schools should be activated or not.
  desc "Import all NYC schools"
  task :import_all_nyc_schools, [:file_name, :activate] => :environment do |t, args|
    csv_text = File.read(args.file_name)
    rows = CSV.parse(csv_text, headers: true)
    ActiveRecord::Base.transaction do
      rows.each_with_index do |row, index|
        row_hash = row.to_hash
        school_name = row_hash['LOCATION_NAME'].strip
        address_line_1 = row_hash['PRIMARY_ADDRESS_LINE_1'].strip
        state_code = row_hash['STATE_CODE'].strip
        principal_phone_number = row_hash['PRINCIPAL_PHONE_NUMBER'].strip

        zcode = "z#{row_hash['LOCATION_CODE'].strip}".downcase
        school = School.where(code: zcode).first_or_initialize
        school.name = school_name if school_name.present?
        school.address_line_1 = address_line_1 if address_line_1.present?
        school.state =  state_code if state_code.present?
        school.active = true if args.activate == true
        school.phone_number = principal_phone_number if principal_phone_number.present?

        if row_hash['Location 1'].present?
          # sometimes the latitude and longitude are on the second line of the cell in CSV
          address_line_2 = row_hash['Location 1'].split("\n")[0].strip
          school.address_line_2 = address_line_2 if address_line_2.present?
          school.borough = borough(address_line_2) if borough(address_line_2).present?
          school.postal_code = address_line_2[-5..] if address_line_2[-5..].present?
        end

        if school.id.nil?
          school.created_at = Time.zone.now
          puts "Creating #{school.name}"
        else
          puts "Updating #{school.name}"
        end
        school.updated_at = Time.zone.now
        school.save
      end
    end
  end

  def borough(address_line_2)
    if address_line_2.downcase.include?('manhattan')
      'MANHATTAN'
    elsif address_line_2.downcase.include?('queens')
      'QUEENS'
    elsif address_line_2.downcase.include?('brooklyn')
      'BROOKLYN'
    elsif address_line_2.downcase.include?('staten')
      'STATEN ISLAND'
    elsif address_line_2.downcase.include?('bronx')
      'BRONX'
    else
      raise "Borough not found for #{address_line_2}"
    end
  end

  # This rake task will destroy and re-create all matches between sierra_codes and zcodes
  # Consequently, each existing code will get a new primary key but nothing depends on that primary key.
  # Example: `rake ingest:overwrite_sierra_code_zcode_matches['data/public/sierra_code_zcode_matches.csv']`
  desc "Overwrite join table for sierra_codes and zcodes"
  task :overwrite_sierra_code_zcode_matches, [:file_name] => :environment do |t, args|
    puts "starting overwrite_sierra_code_zcode_matches"
    csv_text = File.read(args.file_name)
    rows = CSV.parse(csv_text, headers: true)
    ActiveRecord::Base.transaction do
      SierraCodeZcodeMatch.destroy_all
      rows.each_with_index do |row, index|
        row_hash = row.to_hash
        sierra_code = row_hash['sierra_code'].strip
        zcode = row_hash['zcode'].strip
        puts "Creating sierra code #{sierra_code}"
        sierra_data = ['sierra_code', 'zcode']
        sierra_data.each do |column_header_name|
          if !row_hash.key?(column_header_name) || row_hash[column_header_name].blank?
            raise "The #{column_header_name} column is mislabeled or missing from the CSV."
          end
        end
        puts "No need to raise an error.  FYI, the zcode of #{zcode} is in Sierra but not in MLN." unless School.find_by_code(zcode)
        SierraCodeZcodeMatch.create!(sierra_code: sierra_code, zcode: zcode)
      end
      School.all.each do |school|
        # Then ensure all schools have a SierraCodeZcodeMatch by raising the error below
        # to prevent a teacher signing up for a school that isn't represented in Sierra's lookup table 
        # (would cause an error when they place a hold on a book)
        unless school.code == 'MLNSTAFF' || SierraCodeZcodeMatch.find_by_zcode(school.code) || Rails.env.test?
          raise "A SierraCodeZcodeMatch is missing for school ##{school.id} #{school.name} with this zcode: #{school.code}"
        end
      end
    end
  end

  desc "Deactivate schools from authorized list"
  task :deactivate_schools, [] => :environment do |t, args|
    path = 'db/2015SchoolUpdate/dropped-schools.csv' # TODO: remove hardcoding

    dropped_schools = []
    CSV.foreach(path) do |line|
      (name, blank, code) = line
      puts "#{code.downcase}"
      if !(school = School.find_by_code(code.strip.downcase)).nil?
        dropped_schools << "#{code.downcase}"
        if school.active == true
          puts "School to remove from the participating list: #{code.downcase}"
          school.active = false
          school.save
        end
      end
    end

    puts "Total schools dropped: #{dropped_schools.size}"
  end

  # Newer ingest script above
  desc "Selectively activate schools from authorized list"
  task :activate_schools, [] => :environment do |t, args|
    path = 'db/final-schools-dump/School Names.csv'
    CSV.foreach(path) do |line|
      (code, name) = line
      if !(school = School.find_by_code(code)).nil?
        if school.name.strip.downcase != name.strip.downcase
          puts "Warning: Mismatch when activating #{code}:"
          puts "  existing:   #{school.name}"
          puts "  referenced: #{name}"
        end

        school.active = true
        school.save
      end
    end
  end

  desc "Import and active a new set of schools."
  task :new_schools, [] => :environment do |t, args|
    path = 'db/2015SchoolUpdate/new-schools.csv'

    new_schools = []
    CSV.foreach(path) do |line|
      (name, blank, code) = line

      puts "#{code.downcase}"
      new_schools << "#{code.downcase}"

      school = School.find_or_create_by_name name
      school.code = code
      school.active = true
      school.save!
    end

    puts "Total new schools added and active: #{new_schools.size}"
  end

  desc "Import full set of schools from three boroughs, regardless of whether or not they're participating 
        (run activate_schools to selectively activate)"
  task :schools , [] => :environment do |t, args|

    dumps_base = 'db/schools'

    Dir.new(dumps_base).each do |f|
      m = f.match /(\w+)_school_codes/
      next if m.nil?

      borough_name = m[1].underscore.split('_').map(&:capitalize).join(' ')
      school_names = ['Brooklyn','Queens']
      next if school_names.include? borough_name

      borough = Borough.find_or_create_by_name borough_name

      path = "#{dumps_base}/#{f}"
      CSV.foreach(path) do |line|
        next if $. == 1

        puts "#{$.}: #{line}"

        (code, campus_name, school_name) = line

        campus = Campus.find_or_create_by_name campus_name
        campus.borough = borough
        campus.save!

        school = School.find_or_create_by_name school_name
        school.campus = campus
        school.code = code
        school.save!

      end
    end

  end
end
