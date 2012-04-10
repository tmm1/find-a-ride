module RidesHelper
  def user_name(ride)
    ride.offer? ? ride.offerer.try(:full_name) : ride.requestor.try(:full_name)
  end
  
  def vehicle_type_image(ride)
    case ride.vehicle
    when 'two_wheeler' then
      image_tag('2-wheeler.png', :size => '40x40')
    when 'four_wheeler' then
      image_tag('4-wheeler.png', :size => '30x30')
    end
  end
  
  def payment_desc(ride)
    ride.offer? ? "Expects #{ride.payment} in return" : "Can pay #{ride.payment} in return"
  end
  
  def humanize_time(time)
    if time.today?
      time.strftime('Today at %l:%M%p')
    elsif time.to_date == Time.now.advance(:days => 1).to_date
      time.strftime('Tomorrow at %l:%M%p')
    else
      time.strftime('%B %d, %Y at %l:%M%p')
    end
  end
  
  def hookup_label(ride)
    ride.offer? ? 'Request' : 'Offer'
  end

  def user_id(ride)
    ride.offer? ? ride.offerer.id : ride.requestor.id
  end
  
  def vehicle_type_collection
    [['Four-Wheeler', 'four_wheeler'], ['Two-Wheeler', 'two_wheeler'], ['I don\'t care', 'any']]
  end
  
  def payment_type_collection(payment_options=[])
    return [cash, none] if payment_options.empty?
    coll = []
    payment_options.each_with_index do |v, i|
      case i
      when 0
        coll << [v, 'cash']
      when 1
        coll << [v, 'nothing']
      else
      end
    end
    return coll
  end

  def user_uuid
    uuid = UUID.new
    uuid.generate
  end
end