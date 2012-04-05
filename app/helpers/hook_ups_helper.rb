module HookUpsHelper
  def self.formatted_ride_time(time)
    return if time.blank?
    ride_time = time
    ride_time = time.split('at')
    if time.include?('today') || time.include?('tomorrow')
      ride_time = ride_time[1].strip+ ' '+ride_time[0].strip+'.'
    else
      ride_time = ride_time[1].strip+ ' on '+ride_time[0].strip+'.'
    end
    ride_time
  end
end
