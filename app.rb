#!/usr/bin/env ruby

LIB_PATH = File.dirname(__FILE__) + "/lib/lichaam/"
require LIB_PATH
require 'json'
require 'em-websocket'

orgaansysteem = Lichaam::Orgaansysteem

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
  ws.onopen do
    orgaansysteem = orgaansysteem.new
    5000.times { orgaansysteem["Aorta"].vaatinhoud << Lichaam::Bloed.new }
    puts "Orgaansysteem aangemaakt"
  end

  ws.onmessage do |opdracht|
    case opdracht
    when 'vernieuw'
      ws.send orgaansysteem.vernieuw!
    when 'boezemsystole'
      ws.send orgaansysteem["Hart"].boezem_systole
    when 'kamersystole'
      ws.send orgaansysteem["Hart"].kamer_systole
    end
  end

  ws.onclose do
    orgaansysteem = Lichaam::Orgaansysteem
    GC.start
    puts "Orgaansysteem verwijderd"
   end
end