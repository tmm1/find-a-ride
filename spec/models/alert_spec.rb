require 'spec_helper'

describe Alert do
  describe '#attributes and associations' do
    it { should belong_to(:sender), :class_name => 'User' }
    it { should belong_to(:receiver), :class_name => 'User' }
  end
  
  describe '#state transitions' do
    before(:each) do
      @alert = Factory(:alert)
    end
    
    it 'should set initial state as unread' do
      @alert.unread?.should be true
    end
    
    it 'should set state as read' do
      @alert.read
      @alert.read?.should be true
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

