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
    when 'any' then
      'any'
    end
  end

  def other_info_content(ride, hooked_up=false)
    unless hooked_up
      payment_details = ride.offer? ? "Expects #{ride.payment} in return for the ride" : "Can pay #{ride.payment} in return for the ride"
      content = content_tag(:span, payment_details, :id => "ride-payment-info")
      content = content + content_tag(:br) + content_tag(:span, ride.notes, :id => "ride-additional-info" ) if !ride.notes.blank?
      content
    else
      content_tag(:span, 'Ah, It looks like you already might be in touch with this user!', :id => "ride-payment-info")
    end
  end 

  def humanize_time(time)
    if time.today?
      time.strftime('Today at %-l:%M%p')
    elsif time.to_date == Time.now.advance(:days => 1).to_date
      time.strftime('Tomorrow at %-l:%M%p')
    else
      time.strftime('%B %d, %Y at %-l:%M%p')
    end
  end

  def hookup_label(ride)
    ride.offer? ? 'Request' : 'Offer'
  end

  def user_id(ride)
    ride.offer? ? ride.offerer.id : ride.requestor.id
  end

  def vehicle_type_collection
    [['I don\'t care', 'any'],['Four-Wheeler', 'four_wheeler'], ['Two-Wheeler', 'two_wheeler'] ]
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

  def ride_details_json(ride, uuid)
    unless ride.nil?
      contactee = (ride.type == "RideOffer") ? ride.offerer : ride.requestor
      hash = {
        :header             => "#{header_text(ride.type.underscore)} #{contactee.try(:full_name)}",
        :create_hookup_path => user_hook_ups_path(current_user, "#{ride.type.underscore}_id" => ride.try(:id)),
        :contactee_name     => contactee.try(:full_name),
        :origin             => ride.try(:ride_origin).try(:name),
        :destination        => ride.try(:ride_destination).try(:name),
        :ride_time          => humanize_time(ride.try(:ride_time)),
        :contactee_id       => contactee.try(:id),
        :contacter_id       => current_user.try(:id),
        :hookable_id        => ride.try(:id),
        :hookable_type      => ride.try(:type),
        :mobile             => current_user.try(:mobile),
        :hook_up_uniq_id    => uuid
      }
    else
      hash = {}
    end
    hash.to_json.html_safe
  end

  def ride_time_collection
    {"today"                              => "Today",
     "#{2.days.from_now.end_of_day() }"   => "2 Days from now " ,
     "#{7.days.from_now.end_of_day() }"   => "1 week from now",
     "#{14.days.from_now.end_of_day() }"  => "2 weeks from now"}
  end
end
