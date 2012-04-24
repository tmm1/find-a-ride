module AlertsHelper
  def alert_image(alert)
    alert.read? ? image_tag('glyphicons_121_message_empty.png') : image_tag('glyphicons_010_envelope.png')
  end
end
