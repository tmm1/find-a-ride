module FetchContacts

  def FetchContacts.get_gmail_contacts(uname, pwd)
    all_contacts = []
    contacts = Contacts::Gmail.new(uname, pwd).contacts
    contacts && contacts.each do |con|
      all_contacts << con[1]
    end
    all_contacts
  end

end
