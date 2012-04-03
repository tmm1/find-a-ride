module RidesHelper
  def user_name(ride)
    ride.type == 'RideOffer' ? ride.offerer.try(:full_name) : ride.requestor.try(:full_name)
  end
  
  def vehicle_type_image(ride)
    case ride.vehicle
    when '2-Wheeler' then
      image_tag('2-wheeler.png', :size => '40x40')
    when '4-Wheeler' then
      image_tag('4-wheeler.png', :size => '30x30')
    end
  end
  
  def humanize_time(time)
    if time.today?
      time.strftime('today at %l:%M%p')
    elsif time.to_date == Time.now.advance(:days => 1).to_date
      time.strftime('tomorrow at %l:%M%p')
    else
      time.strftime('%B %d, %Y at %l:%M%p')
    end
  end

  def user_info(ride)
    ride.type == 'RideOffer' ? ride.offerer.id : ride.requestor.id
  end
end