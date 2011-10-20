require 'spec_helper'

describe User do
  describe "#attributes and methods" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it { should_not allow_value('1230').for(:mobile) }
    it { should allow_value('1234567890').for(:mobile)}
    it { should_not allow_value('1230').for(:landline) }
    it { should allow_value('1234567890').for(:landline)}

    before(:each) do
      @user = Factory(:user, :first_name => 'testio', :last_name => 'rockio')
    end

    it "should reset passowrd with new password" do
      @user.update_with_password({:password => 'changeme!',:password_confirmation => 'changeme!'})
      @user.password.should == 'changeme!'
    end
    
    it "should update user info without password" do
      @user.update_with_password({:first_name => 'Devise!'})
      @user.first_name.should == 'Devise!'
    end

    it "should update user info with password" do
      @user.update_with_password({:first_name => 'Devise!',:last_name => 'Devise Last Name',:password => 'changemeagain!',:password_confirmation => 'changemeagain!'})
      @user.first_name.should == 'Devise!'
      @user.last_name.should == 'Devise Last Name'
      @user.password.should == 'changemeagain!'
    end
    
    it "should return the full name of the user" do
      @user.full_name.should == 'Testio Rockio'
    end
    
    it "should use full name alias method for name of the user" do
      @user.name.should == @user.full_name
    end
    
    it "should rewrite locations attributes before save" do
      @user.update_attributes({:origin => "maDhapUr", :destination => "konDaPur", :rider => "1"}).should == true
      @user.origin.should == 'Madhapur'
      @user.destination.should == 'Kondapur'
      @user.rider.should be true
    end
    
    it "should validate inclusion of locations attributes in APP_LOCATIONS" do
      @user.update_attributes({:origin => "Kondapur", :destination => "Madhapur", :rider => "", :driver => ""}).should == false
      @user.update_attributes({:origin => "vidhyadhar"}).should == false
      @user.update_attributes({:destination => "vidhyadhar"}).should == false
    end
    
    it 'should fail update with no origin and destination' do
      @user.update_attributes({:origin => "", :destination => ""}).should == false
      @user.update_attributes({:origin => "Madhapur", :destination => ""}).should == false
    end

    it "should fail rider and driver validation" do
      @user.update_attributes({:rider => nil, :driver => nil}).should == false
    end

    it "should update rider or driver successfully" do
      @user.update_attributes({:rider => true, :driver => nil}).should == true
      @user.update_attributes({:rider => nil, :driver => true}).should == true
    end
 
    it "should update inactive attribute successfully" do
      @user.update_attributes({:inactive => 1})
      @user.save.should be true
      @user.inactive.should be true
    end
    
    it 'should return ext_attributes' do
      @user.ext_attributes.keys == ['name', 'phone']
    end
    
    it 'should return the phone' do
      @user.mobile = '3012211221'
      @user.landline = '3032211221'
      @user.phone.should == '3012211221'
    end
  end

  describe "#profile picture" do
    before(:all) do
      @user = Factory(:user)
    end

    it "should fail attachment content_type validation" do
      @user.photo = File.new("spec/data/sample.bmp")
      @user.save.should be false
      @user.errors.to_a.should include("Photo content type must be of type jpeg, png or gif")
    end

    it "should fail attachment file size validation" do
      @user.photo = File.new("spec/data/image_6mb.jpg")
      @user.save.should be false
      @user.errors.to_a.should include("Photo file size cannot be greater than 3 MB")
    end

    it "should save attachment successfully" do
      @user.photo = File.new("spec/data/sample.png")
      @user.save.should be true
      @user.photo_content_type.should == "image/png"
      @user.photo_file_size.should < 3.megabytes
      @user.photo_file_name.should == "sample.png"
      @user.photo.url.include?("http://s3.amazonaws.com/find-a-ride-test/original/#{@user.id}/#{@user.photo_file_name}").should be true
    end
  end
  
  describe "#find matches for drivers" do
    before(:all) do
      @user1 = Factory(:user, :email => 'test@test1.com', :origin => 'Madhapur', :destination => 'Kondapur', :driver => true)
      @user2 = Factory(:user, :email => 'test@test2.com', :origin => 'Madhapur', :destination => 'Kondapur', :driver => true)
      @user3 = Factory(:user, :email => 'test@test3.com', :origin => 'Madhapur', :destination => 'Banjara Hills', :driver => true)
      @user4 = Factory(:user, :email => 'test@test4.com', :origin => 'Kondapur', :destination => 'Miyapur', :driver => true)
      @user5 = Factory(:user, :email => 'test@test5.com', :origin => 'Madhapur', :destination => 'Kondapur', :driver => true)
      @user6 = Factory(:user, :email => 'test@test6.com', :origin => 'Madhapur', :destination => 'Kondapur', :driver => nil, :rider => true)
      @user7 = Factory(:user, :email => 'test@test7.com', :origin => nil, :destination => nil, :driver => true)
    end                       
    
    it "should find matches for Madhapur to Kondapur" do
      matches = User.find_matches_for_drivers('madhApur', 'Kondapur')
      matches.should_not be_nil
      matches.size.should == 3
      matches.collect {|m| m.id}.should == [@user1.id, @user2.id, @user5.id]
    end
    
    it "should not find matches for Miyapur to Hitec city" do
      matches = User.find_matches_for_drivers('Miyapur', 'Hitec city')
      matches.should == []
    end
    
    it "should not find matches for blank origin or destination" do
      matches = User.find_matches_for_drivers
      matches.should == []
    end

    it "should find matches for drivers excluding inactive drivers" do
      matches = User.find_matches_for_drivers('madhApur', 'Kondapur')
      matches.size.should == 3
      @user1.update_attributes({:inactive => 1})
      @user1.save.should be true
      matches = User.find_matches_for_drivers('madhApur', 'Kondapur')
      matches.size.should == 2
      @user1.update_attributes({:inactive => 0})
      @user1.save.should be true
      matches = User.find_matches_for_drivers('madhApur', 'Kondapur')
      matches.size.should == 3
    end
  end
  
  describe "#find matches for riders" do
    before(:all) do
      User.destroy_all
      @user1 = Factory(:user, :email => 'test@test8.com', :origin => 'Madhapur', :destination => 'Kondapur', :rider => true)
      @user2 = Factory(:user, :email => 'test@test9.com', :origin => 'Madhapur', :destination => 'Kondapur', :rider => true)
      @user3 = Factory(:user, :email => 'test@test10.com', :origin => 'Madhapur', :destination => 'Banjara Hills', :rider => true)
      @user4 = Factory(:user, :email => 'test@test11.com', :origin => 'Kondapur', :destination => 'Miyapur', :rider => true)
      @user5 = Factory(:user, :email => 'test@test12.com', :origin => 'Madhapur', :destination => 'Kondapur', :rider => true)
      @user6 = Factory(:user, :email => 'test@test13.com', :origin => 'Madhapur', :destination => 'Kondapur', :rider => nil, :driver => true)
      @user7 = Factory(:user, :email => 'test@test14.com', :origin => nil, :destination => nil, :rider => true)
    end

    it "should find matches for Madhapur to Kondapur" do
      matches = User.find_matches_for_riders('madHapur', 'KonDapur')
      matches.should_not be_nil
      matches.size.should == 3
      matches.collect {|m| m.id}.should == [@user1.id, @user2.id, @user5.id]
    end
    
    it "should not find matches for Miyapur to Hitec city" do
      matches = User.find_matches_for_riders('Miyapur', 'Hitec city')
      matches.should == []
    end

    it "should find matches for riders excluding inactive riders" do
      matches = User.find_matches_for_riders('madhApur', 'Kondapur')
      matches.size.should == 3
      @user1.update_attributes({:inactive => 1})
      @user1.save.should be true
      matches = User.find_matches_for_riders('madhApur', 'Kondapur')
      matches.size.should == 2
      @user1.update_attributes({:inactive => 0})
      @user1.save.should be true
      matches = User.find_matches_for_riders('madhApur', 'Kondapur')
      matches.size.should == 3
    end
  end
  
  describe "#find matches for riders excluding a user" do
     before(:all) do
       User.destroy_all
       @user1 = Factory(:user, :email => 'test@test8.com', :origin => 'Madhapur', :destination => 'Kondapur', :rider => true)
       @user2 = Factory(:user, :email => 'test@test9.com', :origin => 'Madhapur', :destination => 'Kondapur', :rider => true)
       @user3 = Factory(:user, :email => 'test@test10.com', :origin => 'Madhapur', :destination => 'Kondapur', :rider => true)
     end

     it "should find matches for riders excluding a user" do
       matches = User.find_matches_for_riders('madhApur', 'Kondapur', @user3)
       matches.size.should == 2
       matches.collect {|m| m.id}.should == [@user1.id, @user2.id]
     end
   end
  
  describe "#save" do
    before(:all) do
      @user = Factory.build(:user)
      @invalid_user = Factory.build(:user, :password_confirmation => "unmatched password")
    end

    it "should save a valid user" do
      @user.save.should be true
    end

    it "should not save an invalid user" do
      @invalid_user.save.should_not be true
      @invalid_user.errors.to_a.should include("Password doesn't match confirmation")
    end

    it "should not require current password to update account" do
      @user.update_with_password({:email => "test123@test.com"}).should be true
      @user.email.should == "test123@test.com"
    end

    it { should validate_acceptance_of(:terms) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it { should_not allow_value('1230').for(:mobile) }
    it { should allow_value('1234567890').for(:mobile)}
    it { should_not allow_value('1230').for(:landline) }
    it { should allow_value('1234567890').for(:landline)}

    it { should allow_mass_assignment_of(:email) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:password_confirmation) }
    it { should allow_mass_assignment_of(:remember_me) }
    it { should allow_mass_assignment_of(:first_name) }
    it { should allow_mass_assignment_of(:last_name) }
    it { should allow_mass_assignment_of(:driver) }
    it { should allow_mass_assignment_of(:rider) }
    it { should allow_mass_assignment_of(:mobile) }
    it { should allow_mass_assignment_of(:landline) }
    it { should allow_mass_assignment_of(:origin) }
    it { should allow_mass_assignment_of(:destination) }
    it { should allow_mass_assignment_of(:terms) }
    
    it { should_not allow_mass_assignment_of(:encrypted_password)}
    it { should_not allow_mass_assignment_of(:reset_password_token)}
    it { should_not allow_mass_assignment_of(:reset_password_sent_at)}
    it { should_not allow_mass_assignment_of(:remember_created_at)}
    it { should_not allow_mass_assignment_of(:sign_in_count)}
    it { should_not allow_mass_assignment_of(:current_sign_in_at)}
    it { should_not allow_mass_assignment_of(:last_sign_in_at)}
    it { should_not allow_mass_assignment_of(:current_sign_in_ip)}
    it { should_not allow_mass_assignment_of(:last_sign_in_ip)}

    it { should_not allow_mass_assignment_of(:confirmation_token)}
    it { should_not allow_mass_assignment_of(:confirmed_at)}
    it { should_not allow_mass_assignment_of(:confirmation_sent_at)}

  end

  describe "twitter oauth" do
    before(:all) do
      @user1 = Factory(:user, :first_name  => 'amar', :last_name => 'singh', :email => "reshubhan@gmail.com")
    end
    
    it "should not create a duplicate user if the user is already in the system" do
      match = User.find_for_twitter_oauth('reshubhan@gmail.com', 'amar', 'singh', nil)
      match.should == @user1
    end

    it "should create a new user if the user doesnt exist in the system" do
      User.find_by_email("reshubhann@gmail.com").should == nil
      match = User.find_for_twitter_oauth('reshubhann@gmail.com', 'rahul', 'singh', nil)
      match.should_not == @user1
      match.should ==  User.find_by_email("reshubhann@gmail.com")
    end
  end

  describe "facebook oauth " do
    before(:all) do
      @user1 = Factory(:user, :first_name  => 'ask', :last_name => 'singh', :email => "amar@gmail.com")
    end
    it "should not create a duplicate user if the user is already in the system." do
      @user_info = {"extra" => {"user_hash" => {"email" => "amar@gmail.com", "first_name" => "ask", "last_name" => "singh"}}}
      match = User.find_for_facebook_oauth(@user_info, nil)
      match.should == @user1
    end

    it "should create a new user if the user doesnt exist in the system" do
      User.find_by_email("reshubhann@gmail.com").should == nil
      @user_info = {"extra" => {"user_hash" => {"email" => "reshubhann@gmail.com", "first_name" => "Rahul", "last_name" => "singh"}}}
      match = User.find_for_facebook_oauth(@user_info, nil)
      match.should_not == @user1
      match.should ==  User.find_by_email("reshubhann@gmail.com")
    end
  end
end


# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  driver                 :boolean(1)
#  rider                  :boolean(1)
#  mobile                 :string(255)
#  landline               :string(255)
#  origin                 :string(255)
#  destination            :string(255)
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_file_size        :integer(4)
#  photo_updated_at       :datetime
#  inactive               :boolean(1)      default(FALSE)
#

