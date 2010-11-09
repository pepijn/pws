#!/usr/bin/env ruby

LIB_PATH = File.dirname(__FILE__) + "/lib/lichaam/"
require LIB_PATH
require 'json'
require 'em-websocket'

orgaansysteem = Lichaam::Orgaansysteem

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
  ws.onopen do
    orgaansysteem = orgaansysteem.new
    650.times { orgaansysteem["Hart"].linker_boezem.vaatinhoud << Lichaam::Bloed.new }
    puts "Orgaansysteem aangemaakt"
  end

  ws.onmessage do |opdracht|
    case opdracht
    when 'vernieuw'
      ws.send orgaansysteem.vernieuw!
    when 'boezemsystole'
      puts "Boezemsystole"
      orgaansysteem["Hart"].boezem_systole
      ws.send orgaansysteem.vernieuw!
    when 'kamersystole'
      puts "Kamersystole\n\n"
      orgaansysteem["Hart"].kamer_systole
      ws.send orgaansysteem.vernieuw!
    end
  end

  ws.onclose do
    orgaansysteem = Lichaam::Orgaansysteem.reload
    GC.start
    puts "Orgaansysteem verwijderd"
   end
end