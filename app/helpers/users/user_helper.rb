module Users::UserHelper

		def errors_by_accordion_type(user_errors)
		  return {} if user_errors.blank?
		  personal_info_errors = []
		  contact_info_errors = []
		  account_settings_errors = []
		  personal_info_errors << user_errors[:email] if !user_errors[:email].blank?
		  personal_info_errors << user_errors[:first_name] if !user_errors[:first_name].blank?
		  personal_info_errors << user_errors[:last_name] if !user_errors[:last_name].blank?
		  personal_info_errors << user_errors[:photo_content_type] if !user_errors[:photo_content_type].blank?
		  personal_info_errors << user_errors[:photo_file_size] if !user_errors[:photo_file_size].blank?
		  contact_info_errors << user_errors[:mobile] if !user_errors[:mobile].blank?
		  contact_info_errors << user_errors[:landline] if !user_errors[:landline].blank?
      contact_info_errors << user_errors[:origin] if !user_errors[:origin].blank?
      contact_info_errors << user_errors[:destination] if !user_errors[:destination].blank?
		  account_settings_errors << user_errors[:password] if !user_errors[:password].blank?
		  account_settings_errors << user_errors[:password_confirmation] if !user_errors[:password_confirmation].blank?
		  {:personal_info_errors => personal_info_errors, :contact_info_errors => contact_info_errors, :account_settings_errors => account_settings_errors}
		end

end
