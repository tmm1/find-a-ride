class LocationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    unless Location.find_by_name(value.downcase.titleize)
      record.errors[attribute] << 'is not valid'
    end
  end
end