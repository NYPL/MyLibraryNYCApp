# frozen_string_literal: true

class TeacherSetForUserSerializer < ActiveModel::Serializer

  def serializable_hash
    ret = set_serializer_hash
    ret[:active_hold] = hold_serializer_hash
    ret[:user] = user_serializer_hash
    ret[:allowed_quantities] = object[:allowed_quantities]
    ret[:books] = object[:books]
    ret
  end

  private

  def set_serializer_hash
    TeacherSetSerializer.new(object[:teacher_set], options).serializable_hash
  end

  def hold_serializer_hash
    HoldSerializer.new(object[:active_hold], options).serializable_hash unless object[:active_hold].nil?
  end
  
  def user_serializer_hash
    UserSerializer.new(object[:user], options).serializable_hash unless object[:user].nil?
  end
  
end
