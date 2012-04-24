require 'spec_helper'

describe Alert do
  describe '#attributes and associations' do
    it { should validate_presence_of(:sender_id) }
    it { should validate_presence_of(:receiver_id) }
    it { should validate_presence_of(:hook_up_id) }
    
    it { should belong_to(:sender), :class_name => 'User' }
    it { should belong_to(:receiver), :class_name => 'User' }
    it { should belong_to(:hook_up) }
  end
  
  describe '#state transitions' do
    before(:each) do
      Alert.destroy_all
      Ride.destroy_all
      hook_up = Factory(:hook_up, :hookable => Factory(:ride_request))
      @alert = Factory(:alert, :hook_up => hook_up)
    end
    
    it 'should set initial state as unread' do
      @alert.unread?.should be true
    end
    
    it 'should set state as read' do
      @alert.read
      @alert.read?.should be true
    end
  end
  
  describe '#alert scope methods' do
    before(:all) do
      Alert.destroy_all
      Ride.destroy_all
      hook_up1 = Factory(:hook_up, :hookable => Factory(:ride_request))
      hook_up2 = Factory(:hook_up, :hookable => Factory(:ride_offer))
      @alert1 = Factory(:alert, :hook_up => hook_up1)
      @alert2 = Factory(:alert, :hook_up => hook_up2)
      @alert3 = Factory(:alert, :hook_up => hook_up1)
      @alert3.read
    end
    
    it 'should return all unread alerts' do
      Alert.unread.should have(4).things #includes the one created via hook_up1 and hook_up2
      Alert.unread.should_not include @alert3
    end
    
    it 'should return all read alerts' do
      Alert.read.should have(1).things
      Alert.read.should_not include [@alert1, @alert2]
    end
  end
  
  describe '#pusher notification' do
    it 'should generate pusher notification after creation' do
      @alert = Factory.build(:alert)
      lambda {@alert.save}.should_not raise_error(Pusher::Error)
    end
  end
end

# == Schema Information
#
# Table name: alerts
#
#  id          :integer(4)      not null, primary key
#  sender_id   :integer(4)
#  receiver_id :integer(4)
#  state       :string(255)
#  message     :string(5000)
#  created_at  :datetime
#  updated_at  :datetime
#

