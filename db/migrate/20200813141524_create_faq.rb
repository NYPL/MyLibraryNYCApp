# frozen_string_literal: true

class CreateFaq < ActiveRecord::Migration[5.0]
  def change
    create_table :faqs do |t|
      t.text :question
      t.text :answer
      t.integer :position
    end
  end
end
