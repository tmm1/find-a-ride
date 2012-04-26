require 'spec_helper'

describe AlertsHelper do
  
  describe '#alert_image' do
    before(:all) do
      RideOffer.destroy_all
      RideRequest.destroy_all
      @alert = Factory(:alert)
    end
    
    it 'should return unread icon for the unread alert' do
      helper.alert_image(@alert).should == image_tag('glyphicons_010_envelope.png', :class => 'alert-image')
    end
    
    it 'should return the read icon for the read alert' do
      @alert.read
      helper.alert_image(@alert).should == image_tag('glyphicons_121_message_empty.png', :class => 'alert-image')
    end
  end
  
end
