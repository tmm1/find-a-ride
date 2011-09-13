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
    
    it "should return the full name of the user" do
      @user.full_name.should == 'Testio Rockio'
    end
    
    it "should rewrite locations attributes before save" do
      @user.update_attributes({:origin => "maDhapUr"}).should == true
      @user.origin.should == 'Madhapur'
      @user.update_attributes({:destination => "madHapur"}).should == true
      @user.destination.should == 'Madhapur'
    end
    
    it "should validate inclusion of locations attributes in APP_LOCATIONS" do
      @user.update_attributes({:origin => "Madhapur"}).should == true
      @user.update_attributes({:destination => "Madhapur"}).should == true
      @user.update_attributes({:origin => "vidhyadhar"}).should == false
      @user.update_attributes({:destination => "vidhyadhar"}).should == false
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
#

