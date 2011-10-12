module ApplicationHelper
  def user_display_pic(user, size)
    if user.photo_file_name
      image_tag(user.photo.url, :size => size)
    else
      image_tag('blank_profile_picture.png', :size => size)
    end
  end
end
