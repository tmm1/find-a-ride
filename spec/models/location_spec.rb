require 'spec_helper'

describe Location do
  it { should belong_to(:city) }
end


# == Schema Information
#
# Table name: locations
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  city_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

