class TeacherSetForUserSerializer < ActiveModel::Serializer

  def serializable_hash
    ret = set_serializer_hash
    ret[:active_hold] = hold_serializer_hash
    ret[:user] = user_serializer_hash
    ret[:new_holds_count] = object[:new_holds_count]
    ret[:is_copies_available] = object[:is_copies_available]
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
