# frozen_string_literal: true

# TEACHER SET FIELDS WE ARE LEAVING AS STRING:
# :primary_subject
# :call_number
# :availability
# :isbn
# :language
# :primary_language
# :bnumber
#
# BOOK FIELDS WE ARE LEAVING AS STRING:
# :publication_date
# :isbn
# :primary_language

class ChangeTeacherSetAndBookStringsToText < ActiveRecord::Migration[4.2]
  def change
    change_column :teacher_sets, :title, :text
    change_column :teacher_sets, :details_url, :text
    change_column :teacher_sets, :edition, :text
    change_column :teacher_sets, :statement_of_responsibility, :text
    change_column :teacher_sets, :sub_title, :text
    change_column :teacher_sets, :publisher, :text
    change_column :teacher_sets, :series, :text
    change_column :teacher_sets, :set_type, :text
    change_column :teacher_sets, :last_book_change, :text

    change_column :books, :title, :text
    change_column :books, :sub_title, :text
    change_column :books, :format, :text
    change_column :books, :details_url, :text
    change_column :books, :call_number, :text
  end
end
