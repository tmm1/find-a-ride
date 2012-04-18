module ApplicationHelper
  def user_display_pic(user, size)
    if user.photo_file_name && (user.errors[:photo_content_type].blank? && user.errors[:photo_file_size].blank?)
      image_tag(user.photo.url, :size => size)
    else
      image_tag('blank_profile_picture.jpg', :size => size)
    end
  end
end
