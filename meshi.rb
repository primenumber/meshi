#-*- coding: utf-8
require 'uri'
require 'open-uri'
require 'json'

Plugin.create(:meshi) do

  settings "飯テロ" do
    boolean '元のワードもポストする', :meshi_show_orig
  end 

  filter_gui_postbox_post do |gui_postbox|
    buf = Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer
    text = buf.text
    if /<<([[:word:]]+)>>/ =~ text then
      word = $1
      uri = URI.escape("http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="+word)
      response=open(uri)
      data = JSON.load(response.read)
      str = data["responseData"]["results"][0]["url"]
      text = ""
      text += (word + " ") if UserConfig[:meshi_show_orig]
      text += str
    end
    buf.text = text
    [gui_postbox]
  end
end
