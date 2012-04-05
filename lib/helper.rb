module Helper
  def self.to_datetime(date, time)
    "#{date} #{time} +0530".to_datetime
  end
end
