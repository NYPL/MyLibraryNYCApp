# frozen_string_literal: true

class SierraCodeZcodeMatch < ActiveRecord::Base

  def self.create_sierra_code_zcode(zcode, sierra_code)
    sierra_obj = self.initialize_zcode(zcode)
    sierra_obj.sierra_code = sierra_code if sierra_code.present?
    sierra_obj.zcode = zcode if zcode.present?
    sierra_obj.save!
  end


  def self.initialize_zcode(zcode)
    SierraCodeZcodeMatch.where(zcode: zcode).first_or_initialize
  end
end
