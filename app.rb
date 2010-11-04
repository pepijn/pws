#!/usr/bin/env ruby

LIB_PATH = File.dirname(__FILE__) + "/lib/lichaam/"
require LIB_PATH
require 'json'
require 'em-websocket'

EventMachine

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
  ws.onopen    { ws.send "Verbonden"}
  ws.onmessage { |msg| ws.send "Pong: #{msg}" }
  ws.onclose   { puts "WebSocket gesloten" }
end

orgaansysteem = Lichaam::Orgaansysteem.new
hart = orgaansysteem.hart

100.times { hart.rechter_boezem.vaatinhoud << Lichaam::Bloed.new }

# get '/orgaansysteem' do
#   # Begin bij de opvolger van de hartruimte die zojuist heeft gepompt
#   [hart.linker_kamer, hart.rechter_kamer].each do |kamer|
#     huidig = kamer.opvolger
# 
#     # Zolang er een bloeddrukverschil is in de bloedvaten
#     while huidig.bloeddruk > huidig.opvolger.bloeddruk do
#       # Kan er uitwisseling plaatsvinden?
#       if !huidig.klep || huidig.klep.open?
#         # Bereken het drukverschil tussen twee aneenliggende onderdelen
#         drukdelta = (huidig.bloeddruk - huidig.opvolger.bloeddruk) / 2
# 
#         # Verplaats het bloed van hoge druk naar lage druk
#         huidig.verplaats_bloed(drukdelta)
#       end
# 
#       # Verder naar het volgende onderdeel
#       huidig = huidig.opvolger
#     end
#   end
# 
#   content_type :json
#   [
#     orgaansysteem.longen,
#     orgaansysteem.longslagader,
#     orgaansysteem.longader,
#     hart,
#     hart.rechter_boezem,
#     hart.rechter_kamer,
#     hart.linker_boezem,
#     hart.linker_kamer
#   ].to_json
# end