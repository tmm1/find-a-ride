module ContactsService

  def self.fetch_gmail_contacts(user, pwd)
    begin
      all_contacts = []
      contacts = Contacts::Gmail.new(user, pwd).contacts
      contacts && contacts.each do |con|
        all_contacts << con[1]
      end
      all_contacts
    rescue Exception => ex
      raise Exception.new('Sorry! There was a problem retrieving your contacts with the credentials provided.')
    end
  end

end
