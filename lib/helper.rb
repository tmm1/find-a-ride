module Helper
  def self.to_datetime(date, time)
    "#{date} #{time}".to_datetime
  end
end