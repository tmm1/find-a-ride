class RiderDriverValidator < ActiveModel::Validator
  def validate(record)
    if !record.driver and !record.rider
      record.errors[:rider] << 'select atleast one of the two options'
    end
  end
end