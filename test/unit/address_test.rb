require 'test_helper'

class AddressTest < ActiveSupport::TestCase

  test "should not save address without street1" do
    address = addresses(:valid)
    address.street1 = ''
    address.online_application = online_applications(:personal_primary_applicant)
    assert !address.save, "Saved the address without a street1"
    address.online_application = online_applications(:group_primary_applicant)
    assert !address.save, "Saved the address without a street1"
  end

  test "should not save address with street1 longer than 100 characters" do
    address = addresses(:valid)
    address.street1 = 'x' * 101
    address.online_application = online_applications(:personal_primary_applicant)
    assert !address.save, "Saved the address"
    address.online_application = online_applications(:group_primary_applicant)
    assert !address.save, "Saved the address"
  end

  test "should not save address with street2 longer than 100 characters" do
    address = addresses(:valid)
    address.street2 = 'x' * 101
    address.online_application = online_applications(:personal_primary_applicant)
    assert !address.save, "Saved the address"
    address.online_application = online_applications(:group_primary_applicant)
    assert !address.save, "Saved the address"
  end

  test "should not save address with street3 longer than 100 characters" do
    address = addresses(:valid)
    address.street3 = 'x' * 101
    address.online_application = online_applications(:personal_primary_applicant)
    assert !address.save, "Saved the address"
    address.online_application = online_applications(:group_primary_applicant)
    assert !address.save, "Saved the address"
  end

  test "should not save address without city" do
    address = addresses(:valid)
    address.city = ''
    address.online_application = online_applications(:personal_primary_applicant)
    assert !address.save, "Saved the address"
    address.online_application = online_applications(:group_primary_applicant)
    assert !address.save, "Saved the address"
  end

  test "should not save address with state longer than 30 characters" do
    address = addresses(:valid)
    address.state = 'x' * 31 
    address.online_application = online_applications(:personal_primary_applicant)
    assert !address.save, "Saved the address"
    address.online_application = online_applications(:group_primary_applicant)
    assert !address.save, "Saved the address"
  end

  test "should not save address with postal code longer than 20 characters" do
    address = addresses(:valid)
    address.postal_code = 'x' * 21 
    address.online_application = online_applications(:personal_primary_applicant)
    assert !address.save, "Saved the address"
    address.online_application = online_applications(:group_primary_applicant)
    assert !address.save, "Saved the address"
  end

  test "should not save address with invalid postal code" do
    address = addresses(:valid)
    address.postal_code = 'x'
    address.online_application = online_applications(:personal_primary_applicant)
    assert !address.save, "Saved the address"
    address.online_application = online_applications(:group_primary_applicant)
    assert !address.save, "Saved the address"
  end

  test "should save address without postal code" do
    address = addresses(:valid)
    address.postal_code = ''
    address.online_application = online_applications(:personal_primary_applicant)
    assert address.save, "Didn't save the address"
    address.online_application = online_applications(:group_primary_applicant)
    assert address.save, "Didn't save the address"
  end

  test "should save address with other country" do
    address = addresses(:valid)
    address.other_country = 'Sodor'
    address.country_id = 0
    address.online_application = online_applications(:personal_primary_applicant)
    assert address.save, "Didn't save the address"
    address.online_application = online_applications(:group_primary_applicant)
    assert address.save, "Didn't save the address"
  end

  test "should not save address without country or other country" do
    address = addresses(:valid)
    address.other_country = ''
    address.country_id = 0
    address.online_application = online_applications(:personal_primary_applicant)
    assert !address.save, "Saved the address"
    address.online_application = online_applications(:group_primary_applicant)
    assert !address.save, "Saved the address"
  end

  test "should save valid address" do
    address = addresses(:valid)
    address.online_application = online_applications(:personal_primary_applicant)
    assert address.save, "Did not save the address"
    address.online_application = online_applications(:group_primary_applicant)
    assert address.save, "Did not save the address"
  end

  test "empty? should return true for empty address" do
    address = addresses(:empty)
    assert address.empty?, "empty? did not return true"
  end

  test "empty? should not return true for non-empty address" do
    address = addresses(:valid)
    assert !address.empty?, "empty? returned true"
  end

  test "personal? should return true for address of personal application" do
    address = addresses(:valid)
    address.online_application = online_applications(:personal_primary_applicant)
    assert address.personal?, "personal? did not return true"
  end

  test "personal? should not return true for address of group application" do
    address = addresses(:valid)
    address.online_application = online_applications(:group_primary_applicant)
    assert !address.personal?, "personal? returned true"
  end

  test "personal_or_group? should return true for address of personal or group application" do
    address = addresses(:valid)
    address.online_application = online_applications(:personal_primary_applicant)
    assert address.personal_or_group?, "personal_or_group? did not return true for address of personal application"
    address.online_application = online_applications(:group_primary_applicant)
    assert address.personal_or_group?, "personal_or_group? did not return true for address of group application"
  end

end
