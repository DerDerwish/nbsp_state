#!/usr/bin/env ruby

require 'gtk2'
require 'net/http'
require 'json'

# Start
@si        = Gtk::StatusIcon.new
@si.pixbuf = Gdk::Pixbuf.new('pics/unknown.png')
state = 'unknown'

def getStatus
	begin
		json=JSON.parse(Net::HTTP.get(URI('http://status.nobreakspace.org/spaceapi.json')))
		return json["open"] ? 'open' : 'closed'
	rescue Exception => e
		puts e.message
	  return 'unknown'
	end
end

def updateStatus
  state = getStatus
	@si.pixbuf = Gdk::Pixbuf.new("pics/#{state}.png")
	true
end

# Timer
GLib::Timeout.add_seconds(60) do
	updateStatus
end

# Gtk-Main
updateStatus
Gtk.main
