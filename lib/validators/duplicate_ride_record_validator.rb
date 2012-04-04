class DuplicateRideRecordValidator < ActiveModel::Validator

  def validate(record)
    orig = Location.find_by_name(record.orig)
    dest = Location.find_by_name(record.dest)
    ride_time = Helper.to_datetime(record.start_date, record.start_time)
    return if (orig.blank? || dest.blank? || ride_time.blank?)
    old_record = Ride.find_by_origin_and_destination_and_ride_time_and_user_id(orig, dest, ride_time, record.user_id)
    record.errors[:base] << "This is an duplicate record try modifying your request criteria."  unless old_record.blank?
  end

  

end