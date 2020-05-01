# frozen_string_literal: true

class HoldExtendedSerializer < ActiveModel::Serializer

  def serializable_hash
    ret = {}
    ret[:teacher_set] = set_serializer_hash
    ret[:teacher_set_notes] = object[:teacher_set].teacher_set_notes.map { |n| n.content }
    ret[:hold] = hold_serializer_hash
    ret
  end

  private

  def set_serializer_hash
    TeacherSetSerializer.new(object[:teacher_set], options).serializable_hash
  end

  
  def hold_serializer_hash
    HoldSerializer.new(object[:hold], options).serializable_hash unless object[:hold].nil?
  end
 
end
