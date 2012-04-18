require 'spec_helper'

describe HookUp do
  describe "#attributes and methods" do
    it { should validate_presence_of(:contactee_id) }
    it { should validate_presence_of(:contacter_id) }
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:hookable_id) }
    it { should validate_presence_of(:hookable_type) }

    it { should_not allow_value('1230').for(:mobile) }
    it { should_not allow_value('123456789000').for(:mobile)}
    it { should_not allow_value('dadd122112').for(:mobile)}
    it { should allow_value('1234567890').for(:mobile)}
    
    it { should belong_to(:contacter), :class_name => 'User'}
    it { should belong_to(:contactee), :class_name => 'User'}
  end

  describe "#scopes" do
    it "default_scope should ignore hook_ups of expired rides" do
      HookUp.scoped.joins_values.should eql(["INNER JOIN `rides` ON `rides`.`id` = `hook_ups`.`hookable_id`"])
      HookUp.scoped.where_values.should eql(["`rides`.`expires_on` >= '#{Date.today}'"])
    end

    it "should return hook_ups which are not closed" do
      HookUp.not_closed.where_values.should include("state != 'closed'")
    end
  end

  describe '#state of hookup' do
    before(:each) do
      Ride.destroy_all
      user = Factory(:user)
      contactee_user = Factory(:user)
      ride = Factory(:ride)
      @params = {:contactee_id => contactee_user.id, :contacter_id => user.id, :message => 'Hook me up!', :hookable => ride}
    end

    it 'should set the state as offered if hookable is a ride request' do
      @params[:hookable_type] = 'RideRequest'
      hook_up = HookUp.create(@params)
      hook_up.persisted?.should be true
      hook_up.offered?.should be true
    end

    it 'should set the state as requested if hookable is a ride offer' do
      @params[:hookable_type] = 'RideOffer'
      hook_up = HookUp.create(@params)
      hook_up.persisted?.should be true
      hook_up.requested?.should be true
    end

    it 'should close the hook up successfully' do
      hook_up = HookUp.create(@params)
      hook_up.close
      hook_up.closed?.should be true
    end
  end

  describe "#hookup email" do
    before(:all) do
      Ride.destroy_all
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      user = Factory(:user)
      contactee_user = Factory(:user)
      ride = Factory(:ride)
      @params = {:contactee_id => contactee_user.id, :contacter_id => user.id, :message => 'Hook me up!', :hookable => ride}
    end

    it 'should deliver hook_up email successfully' do
      ActionMailer::Base.deliveries.clear
      HookUp.create(@params).should_not be nil
      ActionMailer::Base.deliveries.size.should == 1
    end
  end

  describe "#requested/offered/unclosed" do
    before(:all) do
      HookUp.destroy_all
      Ride.destroy_all
      user = Factory(:user)
      contactee_user = Factory(:user)
      ride = Factory(:ride)
      @hook_up1 = HookUp.create({:contactee_id => contactee_user.id, :contacter_id => user.id, :message => 'Hook me up!', :hookable_id => ride.id, :hookable_type => 'RideRequest'})
      @hook_up2 = HookUp.create({:contactee_id => contactee_user.id, :contacter_id => user.id, :message => 'Hook me up!', :hookable_id => ride.id, :hookable_type => 'RideOffer'})
    end
    
    it 'should return requested' do
      HookUp.requested.should have(1).things
      HookUp.requested.should == [@hook_up2]
    end
    
    it 'should return offered' do
      HookUp.offered.should have(1).things
      HookUp.offered.should == [@hook_up1]
    end
    
    it 'should return unclosed' do
      HookUp.unclosed.should have(2).things
      HookUp.unclosed.should include @hook_up1
      HookUp.unclosed.should include @hook_up2
    end
  end
end



# == Schema Information
#
# Table name: hook_ups
#
#  id            :integer(4)      not null, primary key
#  contactee_id  :integer(4)
#  contacter_id  :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  message       :string(3000)
#  hookable_id   :integer(4)
#  hookable_type :string(255)
#  state         :string(255)
#

