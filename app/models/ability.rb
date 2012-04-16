class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :read, [Ride, RideOffer, RideRequest, HookUp]
      can :manage, [Ride, RideOffer, RideRequest, HookUp], :user_id => user.id
    end
    can :read, [City, Location]
  end
end
