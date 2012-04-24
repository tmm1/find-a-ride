require 'spec_helper'

describe ContactsService do
  
  describe '#fetch_gmail_contacts' do
    it 'should fetch gmail contacts successfully' do
      contacts = []
      lambda {contacts = ContactsService.fetch_gmail_contacts('contactsuser@gmail.com', 'importcontacts')}.should_not raise_error
      contacts.should have_at_least(1).things
    end
    
    it 'should fail authentication when trying to fetch contacts' do
      contacts = []
      lambda {contacts = ContactsService.fetch_gmail_contacts('onthewaytester@gmail.com', 'wr0ngpwd')}.should raise_error
      contacts.should have(0).things
    end
  end
  
end
