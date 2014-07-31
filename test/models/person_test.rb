require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not save person without trusted app" do
    person = people(:person_1)
    person.trusted_app = nil
    assert_not person.save
  end

  test "should not save person without first name" do
    person = people(:person_1)
    person.first_name = nil
    assert_not person.save
  end

  test "should not save person without last name" do
    person = people(:person_1)
    person.last_name = nil
    assert_not person.save
  end

end
