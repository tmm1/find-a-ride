require "spec_helper"

describe UserMailer do
  def create_test_ride(sharer, offerer, user_info)
    Factory(:ride, :sharer => sharer, :offerer => offerer, :user_info => user_info)
  end
  
  before(:all) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    @test_msg = 'Hi Tester'
  end

  describe '#contact_rider_email' do
    before(:each) do 
      ActionMailer::Base.deliveries.clear
    end
    
    it 'should send rider email for an authenticated user' do
      @ride = create_test_ride(Factory(:user), Factory(:user), nil)
      email = UserMailer.contact_rider_email(@ride, @test_msg).deliver
      ActionMailer::Base.deliveries.size.should >= 1
      email.subject.should == 'Find-a-Ride user looking to share a ride' 
      email.to.should == [@ride.offerer.email]
      email.body.include?("#{@ride.sharer.name}").should be_true
      email.body.include?("#{@ride.sharer.email}").should be_true
      email.body.include?("#{@ride.sharer.phone}").should be_true
      email.body.include?("#{@message}").should be_true
    end

    it 'should send rider email for an anonymous user' do
      @ride = create_test_ride(nil, Factory(:user), {:name => 'test from karthik', :email => 'test@k.com', :phone => '1221121211'})
      email = UserMailer.contact_rider_email(@ride, @test_msg).deliver
      ActionMailer::Base.deliveries.size.should >= 1
      email.subject.should == 'Find-a-Ride user looking to share a ride' 
      email.to.should == [@ride.offerer.email]
      email.body.include?("#{@ride.user_info[:name]}").should be_true
      email.body.include?("#{@ride.user_info[:email]}").should be_true
      email.body.include?("#{@ride.user_info[:phone]}").should be_true
      email.body.include?("#{@message}").should be_true
    end
  end

  describe '#contact_driver_email' do
    before(:each) do 
      ActionMailer::Base.deliveries.clear
    end
    
    it 'should send driver email for an authenticated user' do
      @ride = create_test_ride(Factory(:user), Factory(:user), nil)
      email = UserMailer.contact_driver_email(@ride, @test_msg).deliver
      ActionMailer::Base.deliveries.size.should >= 1
      email.subject.should == 'Find-a-Ride user looking to offer a ride' 
      email.to.should == [@ride.sharer.email]
      email.body.include?("#{@ride.offerer.name}").should be_true
      email.body.include?("#{@ride.offerer.email}").should be_true
      email.body.include?("#{@ride.offerer.phone}").should be_true
      email.body.include?("#{@message}").should be_true
    end

    it 'should send driver email for an anonymous user' do
      @ride = create_test_ride(Factory(:user), nil, {:name => 'test from karthik', :email => 'test@k.com', :phone => '1221121211'})
      email = UserMailer.contact_driver_email(@ride, @test_msg).deliver
      ActionMailer::Base.deliveries.size.should >= 1
      email.subject.should == 'Find-a-Ride user looking to offer a ride' 
      email.to.should == [@ride.sharer.email]
      email.body.include?("#{@ride.user_info[:name]}").should be_true
      email.body.include?("#{@ride.user_info[:email]}").should be_true
      email.body.include?("#{@ride.user_info[:phone]}").should be_true
      email.body.include?("#{@message}").should be_true
    end
   end
end
