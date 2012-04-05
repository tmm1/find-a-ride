module HookUpsHelper
  def self.formatted_ride_time(time)
    return if time.blank?
    if time.today?
      ride_time = time.strftime('%l:%M%p today.')
    elsif time.to_date == Time.now.advance(:days => 1).to_date
      ride_time = time.strftime('%l:%M%p tomorrow.')
    else
      ride_time = time.strftime('%l:%M%p on %B %d, %Y.')
    end
    ride_time
  end
end
