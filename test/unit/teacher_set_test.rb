require 'test_helper'

class TeacherSetTest < ActiveSupport::TestCase
  test 'creating a teacher set does not create a version, because papertrail is turned off' do
    # we turn it off this way in app/admin/teacher_sets.rb for creating new sets via the admin dashboard
    teacher_set = crank!(:teacher_set)
    assert PaperTrail::Version.count == 0
  end

  test 'updating a teacher set creates a version' do
    teacher_set = crank!(:teacher_set)

    teacher_set.update_attributes(title: 'Title2')
    assert PaperTrail::Version.count == 1
  end
end
