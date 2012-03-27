class TimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?
    begin
      Time.parse(value) 
    rescue
      record.errors[attribute] << 'is not valid'
    end
  end
end