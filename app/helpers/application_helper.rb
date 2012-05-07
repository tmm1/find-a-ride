module ApplicationHelper
  def user_display_pic(user, size)
    if user.photo_file_name && (user.errors[:photo_content_type].blank? && user.errors[:photo_file_size].blank?)
      image_tag(user.photo.url, :alt => 'Pic', :size => size)
    else
      image_tag('blank_profile_picture.jpg', :alt => 'Pic', :size => size)
    end
  end

  def sidebar_entries
    content = ''
    [ {:text => "Search", :href => search_rides_path},
      {:text => "Post an offer", :href => new_ride_offer_path},
      {:text => "Request a ride", :href => new_ride_request_path},
      {:text => "My requests and offers", :href => list_user_rides_path(current_user)},
      {:text => "My recent activity", :href => recent_path(current_user)}
    ].each do |entry|
      content << content_tag(:li, :class => (request.fullpath == entry[:href] ? 'active' : '')) do
        link_to(entry[:text], entry[:href])
      end
    end
    content.html_safe
  end
end
