#-*- coding: utf-8
require 'uri'
require 'open-uri'
require 'json'

Plugin.create(:meshi) do
  filter_gui_postbox_post do |gui_postbox|
    buf = Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer
    text = buf.text
    if /<<([[:word:]]+)>>/ =~ text then
      uri = URI.escape("http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="+$1)
      response=open(uri)
      data = JSON.load(response.read)
      str = data["responseData"]["results"][0]["url"]
      text[/<<([[:word:]]+)>>/,0] = str
    end
    buf.text = text
    [gui_postbox]
  end
end
