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
end