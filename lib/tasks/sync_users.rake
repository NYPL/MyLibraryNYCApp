# frozen_string_literal: true

require 'csv'
require 'pry'


namespace :sync_users do

  # Check how many accounts needed to be fixed in the last month.
  # Iterate through the users in the Sierra CSV.
  # For each user, see if they exist in the MLN database.
  # If they do, and if the MLN user was created within the last month, while the Sierra user has been there for longer than that,
  # then this is a user account manually fixed by the Library Outreach team.
  # call like this:  RAILS_ENV=development rake check_user_fixes:check_mismatch['data/private/20181128_sierra_mln_user_accounts.csv',2,1,'23333090060508']
  desc "Check manually made account fixes"
  task :check_user_fixes, [:file_name, :start, :limit, :barcode] => :environment do |t, args|
    # if barcode is set, then only checks that barcode for Sierra-MLN mismatch
    args.with_defaults(:file_name => nil, :start=> 0, :limit => 0, :barcode => nil)

    csv_start = args.start.to_i
    csv_limit = args.limit.to_i

    csv_barcode = args.barcode

    # Example:  'data/private/20181128_sierra_mln_user_accounts.csv'
    csv_path = args.file_name

    # \u03EA is a unicode character that will never happen in our Sierra output file.
    # we need this, because the Sierra output has some junk data that's making the CSV gem trip up.
    # however, this means that we'll now need to strip the double quotes from around the ingested field values ourselves.
    CSV.foreach(csv_path, col_sep: "|", quote_char: "\u03EA") do |line|
      # don't process the header row
      next if $. == 1

      # if we're only reading a few lines of the csv, then see if we can stop, before reading any further
      next if (csv_start.positive? && $. < csv_start)
      break if (csv_limit.positive? && $. >= (csv_start + csv_limit))

      # "P BARCODE"|"EMAIL ADDR"|"PIN"|"EXP DATE"|"PCODE3"|"P TYPE"|"TOT CHKOUT"|"HOME LIBR"|"MBLOCK"|"PCODE4"|"PATRN NAME"|"ADDRESS"|
      # "CREATED(PATRON)"|"UPDATED(PATRON)"
      # Example:  "23333106701234"|"name@gmail.com"|"Tn/jC7sHXQpfw"|"10-01-2018"|"1"|"153"|"4"|"ea   "|"-"|"895"|"LASTNAME, FIRSTNAME"|"123
      # MAIN ST, NY 10001"|"05-20-2009 15:23"|"07-02-2018"
      (barcode, email, pin, expiration, pcode3, ptype, total_checkouts, home_library, manual_block, pcode4, name, address, sierra_created,
       sierra_updated) = line

      # inore bad data, and move on to the next line
      next if (barcode.nil?)

      # clean off any leading/trailing spaces and double quotes
      barcode = barcode.strip.downcase
      barcode = barcode.chomp('"').reverse.chomp('"').reverse
      sierra_created = sierra_created.chomp('"').reverse.chomp('"').reverse

      # if a barcode was passed, we're looking for that barcode, and should stop processing once we find it.
      if (!csv_barcode.present? && csv_barcode == barcode)
        csv_start = $.
        csv_limit = 1
      end

      # is there a user in the mln database that matches this user from Sierra?
      mln_user = User.find_by_barcode(barcode)
      # Yes, there is.  Now see if the user was created in MLN over the last month, while being old in Sierra.
      # was the user created after a month ago in mln database?
      if !mln_user.present? && (mln_user.created_at > 1.month.ago)
        begin
          date_sierra_created = DateTime.strptime(sierra_created, '%m-%d-%Y %H:%M')

          # was the user created before a month ago in Sierra?
          if (date_sierra_created < 1.month.ago)
            puts "manually repaired user=#{barcode}, mln_user.id=#{mln_user.id}, mln_user.created_at=#{mln_user.created_at},
             mln_user.updated_at=#{mln_user.updated_at}, sierra_created=#{sierra_created}, sierra_updated=#{sierra_updated}"
          end
        rescue => e
          puts "broke: #{e}"
        end
      end
    end #foreach sierra row
  end #check_user_fixes


  ## NOTE: This method is not complete.  We're abandoning the task, until we can be sure it's warranted.
  # We think it may not be warranted, based on the output of the check_user_fixes task.
  #
  # Check how many accounts are in Sierra, but not in MLN.
  # Iterate through the users in the Sierra CSV.
  # For each user, see if they exist in the MLN database.
  # If they do not, then output the user, so we can review them later.
  # TODO:  later functionality -- write to db a new user.
  # call like this:  RAILS_ENV=development rake sync_users:ingest_mismatched_sierra_users['data/private/20181128_sierra_mln_user_accounts.csv',2,1,
  # '23333090060508']
  # @param safetyoff -- manually set this in the task call, to really truly write to the DB (a destructive change)
  desc "Check and Automatically Fix Sierra-MLN mismatch"
  task :ingest_mismatched_sierra_users, [:file_name, :start, :limit, :barcode, :safetyoff] => :environment do |t, args|
    puts "ingest_mismatched_sierra_users begin"
    # if barcode is set, then only checks that barcode for Sierra-MLN mismatch
    args.with_defaults(:file_name => nil, :start=> 0, :limit => 0, :barcode => nil, :safetyoff => false)
    safetyoff = args.safetyoff

    csv_start = args.start.to_i
    #start = 1 if start == 0  # don't think I have to do this, since I have defaults
    csv_limit = args.limit.to_i
    #limit = 1 if limit == 0

    csv_barcode = args.barcode

    # Example:  'data/private/20181128_sierra_mln_user_accounts.csv'
    csv_path = args.file_name

    mln_fixed_users = []

    # \u03EA is a unicode character that will never happen in our Sierra output file.
    # we need this, because the Sierra output has some junk data that's making the CSV gem trip up.
    # however, this means that we'll now need to strip the double quotes from around the ingested field values ourselves.
    CSV.foreach(csv_path, col_sep: "|", quote_char: "\u03EA") do |line|
      #puts "current_line_num=#{$.}, csv_start=#{csv_start}, limit=#{csv_limit}"
      # don't process the header row
      next if $. == 1

      # if we're only reading a few lines of the csv, then see if we can stop, before reading any further
      next if (csv_start.positive? && $. < csv_start)
      break if (csv_limit.positive? && $. >= (csv_start + csv_limit))

      # "P BARCODE"|"EMAIL ADDR"|"PIN"|"EXP DATE"|"PCODE3"|"P TYPE"|"TOT CHKOUT"|"HOME LIBR"|"MBLOCK"|"PCODE4"|"PATRN NAME"
      # |"ADDRESS"|"CREATED(PATRON)"|"UPDATED(PATRON)"
      # Example:  "23333106701234"|"name@gmail.com"|"Tn/jC7sHXQpfw"|"10-01-2018"|"1"|"153"|"4"|"ea   "|"-"|"895"|"LASTNAME,
      # FIRSTNAME"|"123 MAIN ST, NY 10001"|"05-20-2009 15:23"|"07-02-2018"
      (barcode, email, pin, expiration, pcode3, ptype, total_checkouts, home_library, manual_block, pcode4, name, address, sierra_created,
       sierra_updated) = line

      # inore bad data, and move on to the next line
      next if (barcode.nil?)

      # clean off any leading/trailing spaces and double quotes
      barcode = barcode.strip.downcase
      barcode = barcode.chomp('"').reverse.chomp('"').reverse
      sierra_created = sierra_created.chomp('"').reverse.chomp('"').reverse

      # if a barcode was passed, we're looking for that barcode, and should stop processing once we find it.
      if (!csv_barcode.nil? && csv_barcode == barcode)
        csv_start = $.
        csv_limit = 1
      end

      # is there a user in the mln database that matches this user from Sierra?
      mln_user = User.find_by_barcode(barcode)
      if mln_user.nil?
        # there isn't.  now then, we might not be finding this user because of garbled or bad data in the Sierra
        # output csv.  output the user, and let the human investigate.

        puts "user=#{barcode}, sierra_created=#{sierra_created}, sierra_updated=#{sierra_updated}, email=#{email}"

        # Create a user in the MLN db to match the user from Sierra
        
      end

    end #for each Sierra row

  end #check_mismatch task

end #namespace
