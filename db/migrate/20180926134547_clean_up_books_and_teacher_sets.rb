# frozen_string_literal: true

class CleanUpBooksAndTeacherSets < ActiveRecord::Migration[3.2]
  def up
    ActiveRecord::Base.transaction do
      # Teacher sets already have bnumbers after testing each of the teacher_sets,
      # I've found that teacher_set.update_bnumber! would return the same result as existing bnumbers
      # so we're only going to update the bnumbers of books in this migration.
      Book.all.each do |book|
        puts "Updating bnumber for book ##{book.id}"
        book.update_bnumber!
      end

      puts "Calling rake task to clean up teacher sets and books"
      Rake::Task['cleanup:bib_records'].invoke('book teacher_set')
    end
  end
end
