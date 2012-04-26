module AlertsHelper
  def alert_image(alert)
    img_url = alert.read? ? 'glyphicons_121_message_empty.png' : 'glyphicons_010_envelope.png'
    image_tag(img_url, :class => 'alert-image')
  end
end
