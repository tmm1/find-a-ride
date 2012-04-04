class DateTimeValidator < ActiveModel::Validator
  def validate(record)
    unless record.start_date.blank? || record.start_time.blank?
      if DateTime.parse(record.start_date).strftime("%d-%m-%Y") == Time.now.strftime("%d-%m-%Y")
        if Time.parse(record.start_time) <= Time.now
          record.errors[:start_time] << "can't be in the past"
        end
      end
    end
  end
end
