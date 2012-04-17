module HookUpsHelper
  def formatted_ride_time(time)
    return if time.blank?
    if time.today?
      return time.strftime('%l:%M%p today.')
    elsif time.to_date == Time.now.advance(:days => 1).to_date
      return time.strftime('%l:%M%p tomorrow.')
    else
      return time.strftime('%l:%M%p on %B %d, %Y.')
    end
  end
  
  def header_text(type)
    type.eql?('ride_offer') ? 'Request a ride from' : 'Offer a ride to' 
  end
  
  def activity_text(hook_up, user)
    if hook_up.hookable.request?
      hook_up.contacter.eql?(user) ? "You offered #{hook_up.contactee.try(:full_name)} a ride" : "#{hook_up.contacter.try(:full_name)} offered you a ride"
    elsif hook_up.hookable.offer?
      hook_up.contacter.eql?(user) ? "You requested #{hook_up.contactee.try(:full_name)} a ride" : "#{hook_up.contacter.try(:full_name)} requested you a ride"
    end
  end
end
