require 'spec_helper'

describe ApplicationHelper do
  include Devise::TestHelpers

  it 'should return the image tag for the user dp for size 75x75' do
    user = Factory(:user)
    tag = helper.user_display_pic(user, '75x75')
    tag.should_not be_nil
    tag.should == image_tag('blank_profile_picture.jpg', :alt => 'Pic', :size => '75x75')
  end
  it 'should return the image tag for the user dp for size 100x100' do
    user = Factory(:user)
    tag = helper.user_display_pic(user, '100x100')
    tag.should_not be_nil
    tag.should == image_tag('blank_profile_picture.jpg', :alt => 'Pic', :size => '100x100')
  end

  describe '#uri_matches?' do
    before(:each) do
      helper.request.stub!(:fullpath).and_return(search_ride_offers_path)
    end

    it 'should return true if the uri matches any of the paths given' do
      helper.uri_matches?([search_rides_path, search_ride_requests_path, search_ride_offers_path]).should be_true
      helper.uri_matches?([search_ride_offers_path]).should be_true
    end

    it 'should match the uri irrespective of arguments' do
      helper.uri_matches?([search_ride_offers_path(:dest => 'Madhapur', :orig => 'Kukatpally')]).should be_true
    end

    it 'should return false only if the uri doesn\'t match all of the paths given' do
      helper.uri_matches?([search_ride_requests_path, search_rides_path]).should be_false
    end

    it 'should return false and not raise error if an empty \'paths\' is given' do
      helper.uri_matches?([]).should be_false
      helper.uri_matches?(nil).should be_false
    end
  end

  describe '#sidebar_entries' do
    before(:each) do
      @user = Factory(:user)
    end

    it 'should include the five entries' do
      sign_in @user
      tag = helper.sidebar_entries
      tag.scan('<li').should have(6).things
      tag.should include(link_to("Search", search_rides_path))
      tag.should include(link_to("Post an offer", new_ride_offer_path))
      tag.should include(link_to("Request a ride", new_ride_request_path))
      tag.should include(content_tag(:li, nil, :class => 'divider'))
      tag.should include(link_to("My requests and offers", list_user_rides_path(@user)))
      tag.should include(link_to("My recent activity", recent_path(@user)))
    end

    it 'should highlight active entry' do
      helper.request.stub!(:fullpath).and_return(search_rides_path)
      sign_in @user
      tag = helper.sidebar_entries
      tag.should include(content_tag(:li, :class => 'active') { link_to("Search", search_rides_path) })
    end
  end
end
