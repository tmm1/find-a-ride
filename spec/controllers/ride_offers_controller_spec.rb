require 'spec_helper'

describe RideOffersController do
  render_views
  include Devise::TestHelpers
  before(:all) do
    @login_user = Factory(:user)
  end

  describe "#new" do
    it 'should render new' do
      sign_in @login_user
      get :new
      response.should be_success
      response.should render_template(:new)
    end
  end

  describe "#create" do
    it "should successfully create a new ride offer" do
      sign_in @login_user
      params = Factory.attributes_for(:ride_offer, :vehicle => 'two_wheeler')
      post 'create', :ride_offer => params
      response.should redirect_to(search_ride_requests_path(params))
      ride_offer = assigns(:ride_offer)
      ride_offer.should_not be_nil
      ride_offer.ride_origin.should == Location.find_by_name(params[:orig])
      ride_offer.ride_destination.should == Location.find_by_name(params[:dest])
      ride_offer.ride_time.should == "#{params[:start_date]} #{params[:start_time]} +0530".to_datetime
      ride_offer.vehicle.should == 'two_wheeler'
    end

    it "should fail creating an invalid ride offer" do
      sign_in @login_user
      params = Factory.attributes_for(:ride_offer)
      params[:orig] = 'unknown'
      params[:start_time] = 'blah'
      post 'create', :ride_offer => params
      response.should be_success
      response.should render_template(:new)
      ride_offer = assigns(:ride_offer)
      ride_offer.should_not be_nil
      ride_offer.valid?.should be false
    end

    it "should fail creating a duplicate ride offer" do
      sign_in @login_user
      RideOffer.create(RideOffer.create({:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '10/12/2012', :start_time => '10/12/2012 01:30:00', :type=>"RideOffer"})).should_not be nil
      post 'create', :ride_offer => {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '10/12/2012', :start_time => '10/12/2012 01:30:00', :type=>"RideOffer"}
      ride_offer = assigns(:ride_offer)
      ride_offer.valid?.should be false
      ride_offer.errors.first.should include("Oops. You already put in one with similar criteria!")
    end
  end

  describe "#search" do
    before(:all) do
      RideOffer.destroy_all
      Factory(:ride_offer)
      Factory(:ride_offer)
    end

    it "should render the search page with results" do   
      RideOffer.stub!(:search).and_return(RideOffer.limit(2))
      sign_in @login_user
      get 'search', {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'four_wheeler'}
      response.should be_success
      response.should render_template(:results)
      assigns(:paginated_results).should have(2).things
    end   

    it "should render the search page with with no results" do   
      RideOffer.stub!(:search).and_return(RideOffer.where(:origin => 'nowhere'))
      sign_in @login_user
      get 'search', {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'four_wheeler'}
      response.should be_success
      response.should render_template(:results)
      assigns(:paginated_results).should have(0).things
    end

    it "ajax request should render the search page with no results" do
      RideOffer.stub!(:search).and_return(RideOffer.limit(2))
      sign_in @login_user
      xhr 'get', 'search', {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'four_wheeler',:page =>"2"}
      response.should be_success
      response.should render_template(:grid)
      assigns(:paginated_results).should have(0).things
    end

    it "ajax request should render the search page with results" do
      RideOffer.stub!(:search).and_return(RideOffer.limit(2))
      sign_in @login_user
      xhr 'get', 'search', {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'four_wheeler',:page =>"1"}
      response.should be_success
      response.should render_template(:grid)
      assigns(:paginated_results).should have(2).things
    end

  end

  describe "for inactive users" do
    before(:all) do
      @inactive_user = Factory(:user, :inactive => true)
    end
    [
      {:action => :new,    :method => :get},
      {:action => :create, :method => :post, :args => {:ride_offer    => Factory.attributes_for(:ride_offer)}},
      {:action => :search, :method => :post, :args => {:search_params => Factory.attributes_for(:ride)}}
    ].each do |method|
      it "##{method[:action]} should be redirected to HomeController#inactive" do
        sign_in @inactive_user
        send method[:method], method[:action], method[:args]
        response.should redirect_to(inactive_home_index_path)
      end
    end
  end
end
