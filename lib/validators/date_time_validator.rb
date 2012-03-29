class DateTimeValidator < ActiveModel::Validator
  def validate(record)
    if (record.start_date && !record.start_date.blank?)
      if (DateTime.parse(record.start_date).strftime("%d-%m-%Y") == Time.now.strftime("%d-%m-%Y"))
        if (!record.start_time.blank? && Time.parse(record.start_time) <= Time.now)
          record.errors[:start_time] << "can't be the past"
        end
      end
    end
  end
end
