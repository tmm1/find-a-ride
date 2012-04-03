require 'spec_helper'

describe HookUp do
  describe "#attributes and methods" do
    it { should validate_presence_of(:contactee_id) }
    it { should validate_presence_of(:contacter_id) }
    it { should validate_presence_of(:message) }

    it { should_not allow_value('9247').for(:phone_number) }
    it { should allow_value('9246567890').for(:phone_number)}   
  end
end

# == Schema Information
#
# Table name: hook_ups
#
#  id           :integer(4)      not null, primary key
#  contactee_id :integer(4)
#  contacter_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  message      :string(3000)
#

