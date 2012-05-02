require 'spec_helper'

describe RidesController do
  render_views
  include Devise::TestHelpers
  before(:all) do
    @login_user = Factory(:user)
  end

  describe "#new" do
    it "should render new" do     
      sign_in @login_user
      get 'new'
      response.should be_success
      response.should render_template(:new)
      assigns(:ride_request).should_not be nil
      assigns(:ride_offer).should_not be nil
    end
  end

  describe "#index" do
    it "should render index" do     
      sign_in @login_user
      get 'index'
      response.should be_success
      response.should render_template(:index)      
    end
    it "ajax request should render grid" do
      sign_in @login_user
      xhr :get , 'index'
      response.should be_success
      response.should render_template(:index)
      response.should render_template(:grid) 
    end
  end
  
  describe '#search' do
    it "should perform search for valid criteria" do
      sign_in @login_user
      search_params = Factory.attributes_for(:ride)
      post 'search', {:ride => search_params}
      response.should redirect_to(search_ride_offers_path(search_params.merge({:from => :search})))
      assigns(:ride).should be_valid
    end
    
    it "should not perform search for invalid criteria" do
      sign_in @login_user
      search_params = Factory.attributes_for(:ride)
      search_params[:orig] = nil
      search_params[:dest] = nil
      post 'search', {:ride => search_params}
      response.should be_success
      response.should render_template(:search)
      assigns(:ride).should_not be_valid
    end
  end

  describe "#inactive users" do
    before(:all) do
      @inactive_user = Factory(:user, :inactive => true)
    end

    [
      {:action => :new,    :method => :get},
      {:action => :index,  :method => :get},
      {:action => :search, :method => :post, :args => {:search_params => Factory.attributes_for(:ride)}}
    ].each do |method|
      it "#{method[:action]} should redirect to inactive page" do
        sign_in @inactive_user
        send method[:method], method[:action], method[:args]
        response.should redirect_to(inactive_home_index_path)
      end
    end
  end

  describe "#destroy" do
    before(:each) do
      @ride = Factory(:ride_offer, :offerer => @login_user)
    end

    def do_delete(options = {})
      xhr :delete, :destroy, {:user_id => @login_user.id, :id => @ride.id}.merge(options)
    end

    it "should destroy a ride successfully" do
      sign_in @login_user
      lambda { do_delete }.should change(Ride, :count).by(-1)
      assigns[:ride].should eql(@ride)
      flash.now[:success].should eql("The #{@ride.humanize_type} was deleted successfully")
      response.content_type.should eql(Mime::JS.to_s)
    end

    it "should not delete the ride if the user doesn't own it" do
      user = Factory(:user)
      sign_in user
      lambda { do_delete(:user_id => user.id) }.should_not change(Ride, :count)
      assigns[:ride].should eql(@ride)
      response.content_type.should eql(Mime::JS.to_s)
      flash.now[:error].should eql("The #{@ride.humanize_type} was not deleted")
    end
  end

  describe "#list" do
    before(:all) do
      RideOffer.destroy_all
      RideRequest.destroy_all
      RideOffer.record_timestamps = false
      locs = Location.limit(6).select(:name).map(&:name)
      @ride_offer1 = Factory(:ride_offer, :offerer => @login_user, :orig => locs[0], :dest => locs[1], :created_at => 3.days.ago)
      @ride_offer2 = Factory(:ride_offer, :offerer => @login_user, :orig => locs[2], :dest => locs[3], :created_at => 1.day.ago)
      @ride_offer3 = Factory(:ride_offer, :offerer => @login_user, :orig => locs[4], :dest => locs[5], :created_at => 2.days.ago)
    end

    after(:all) do
      RideOffer.record_timestamps = true
    end

    it "should list the ride_requests and ride_offers" do
      sign_in @login_user
      get :list, :user_id => @login_user.id
      response.should be_success
      response.should render_template(:list)
      assigns[:ride_requests].should have(0).things
      assigns[:ride_offers].should have(3).things
      assigns[:ride_offers].should == [@ride_offer2, @ride_offer3, @ride_offer1]
    end
  end
end
