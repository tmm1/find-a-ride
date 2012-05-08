module ApplicationHelper
  def user_display_pic(user, size)
    if user.photo_file_name && (user.errors[:photo_content_type].blank? && user.errors[:photo_file_size].blank?)
      image_tag(user.photo.url, :alt => 'Pic', :size => size)
    else
      image_tag('blank_profile_picture.jpg', :alt => 'Pic', :size => size)
    end
  end

  def uri_matches?(paths)
    paths ||= []
    regex = %r|^([^?]*)(\??.*)$|
    paths.any? do |path|
      request.fullpath.sub(regex, '\1') == path.sub(regex, '\1')
    end
  end

  def sidebar_entries
    entries = [
      {:text => "Search",         :paths => [search_rides_path, search_ride_requests_path, search_ride_offers_path]},
      {:text => "Post an offer",  :paths => [new_ride_offer_path, ride_offers_path]},
      {:text => "Request a ride", :paths => [new_ride_request_path, ride_requests_path]},
      {}, # divider
      {:text => "My requests and offers", :paths => [list_user_rides_path(current_user)]},
      {:text => "My recent activity",     :paths => [recent_path(current_user)]}
    ]

    content = ''
    entries.each do |entry|
      if entry.empty?
        content << content_tag(:li, nil, :class => 'divider')
      else
        content << content_tag(:li, :class => uri_matches?(entry[:paths]) ? 'active' : '') do
          link_to entry[:text], entry[:paths].first
        end
      end
    end
    content.html_safe
  end
end
