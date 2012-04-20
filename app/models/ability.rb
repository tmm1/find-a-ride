class Ability
  include CanCan::Ability

  def initialize(user)
    if user #logged in user access
      can :read, [Ride, RideOffer, RideRequest, HookUp]
      can :manage, [Ride, RideOffer, RideRequest], :user_id => user.id
      can :manage, HookUp, :contacter_id => user.id
      can :read, Alert, :receiver_id => user.id
      can :manage, Alert, :sender_id => user.id 
    end
    
    # anonymous user access
    can :read, [City, Location]
  end
end
