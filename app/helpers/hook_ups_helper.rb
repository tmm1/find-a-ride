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
    type.eql?('RideOffer') ? 'Offer a ride to' : 'Request a ride from'
  end
end
