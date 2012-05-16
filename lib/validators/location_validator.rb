class LocationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    city = City.find_by_name(record.current_city)
    unless city.locations.find_by_name(value.downcase.titleize)
      record.errors[attribute] << 'is not valid'
    end
  end
end