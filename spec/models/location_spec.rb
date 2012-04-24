require 'spec_helper'

describe Location do
  it { should belong_to(:city) }

  describe '#find_by_name' do
    before(:all) do
      @location = Factory(:location, :name => 'Location XYZW')
    end

    after(:all) do
      @location.destroy
    end

    it 'should find records irrespective of case' do
      Location.find_by_name('Location XYZW').should == @location
      Location.find_by_name('LOCATION XYZW').should == @location
      Location.find_by_name('locATIOn xYzw').should == @location
    end
  end
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

