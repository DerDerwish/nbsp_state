#!/usr/bin/env ruby

require 'gtk2'
require 'net/http'
require 'json'

# URI to spaceapi-file
@uri = URI('http://status.nobreakspace.org/spaceapi.json')

# Start
@si        = Gtk::StatusIcon.new
@si.pixbuf = Gdk::Pixbuf.new('pics/unknown.png')
@state = 'unknown'
@http = nil

def getStatus
	begin
		@http = Net::HTTP.new(@uri.hostname)
		res = @http.request_get(@uri.path)
		json=JSON.parse(res.body)
	rescue Exception => e
		puts e.message
		puts e.backtrace.inspect
		@http = nil
		puts "couldn't open http"
	  return 'unknown'
	end
	@http = nil
	return json["open"] ? 'open' : 'closed'
end

def updateStatus
  @state = getStatus
	begin
		@si.pixbuf = Gdk::Pixbuf.new("pics/#{@state}.png")
	rescue Exception => e
		puts "could not set pics/#{@state}.png"
		puts e.message
		puts e.backtrace.inspect
	end
	true
end

# Timer
GLib::Timeout.add_seconds(60) do
	updateStatus
end

# Gtk-Main
updateStatus
Gtk.main
