require 'spec_helper'

describe City do
  it { should have_many(:locations) }
end

# == Schema Information
#
# Table name: cities
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

