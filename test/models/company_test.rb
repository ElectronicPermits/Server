require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "should not save company without trusted_app" do
    company = companies(:company_1)
    company.trusted_app = nil 
    assert_not company.save
  end

  test "should not save company without name" do
    company = companies(:company_1)
    company.name = nil 
    assert_not company.save
  end

end
