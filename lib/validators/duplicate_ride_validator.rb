class DuplicateRideValidator < ActiveModel::Validator
  def validate(record)
    orig = Location.find_by_name(record.orig)
    dest = Location.find_by_name(record.dest)
    ride_time = Helper.to_datetime(record.start_date, record.start_time)
    return if (orig.blank? || dest.blank? || ride_time.blank?)
    dup = Ride.find_by_origin_and_destination_and_ride_time_and_user_id_and_type_and_vehicle(orig, dest, ride_time, record.user_id, record.type, record.vehicle)
    record.errors[:base] << "Oops. You already put in one with similar criteria!"  unless dup.blank?
  end
end