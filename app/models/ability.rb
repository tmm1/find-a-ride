class Ability
  include CanCan::Ability

  def initialize(user)
    if user #logged in user access
      can :read, [Ride, RideOffer, RideRequest, HookUp]
      can :manage, [Ride, RideOffer, RideRequest, HookUp], :user_id => user.id
    end
    
    # anonymous user access
    can :read, [City, Location]
  end
  
end
