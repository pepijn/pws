#!/usr/bin/env ruby

LIB_PATH = File.dirname(__FILE__) + "/lib/"
require LIB_PATH + 'pws'
require 'json'
require 'eventmachine'

module OrgaansysteemServer
  def post_init
    @orgaansysteem = Lichaam::Orgaansysteem.new
    650.times { @orgaansysteem["Longader"].bloed << Lichaam::Bloed::RodeBloedcel.new }
    1000.times { @orgaansysteem["Longen"].alveolair_vocht << Omgeving::Moleculen::Zuurstof.new }
    puts "Orgaansysteem aangemaakt"
  end

  def receive_data(opdracht)
    case opdracht
    when 'vernieuw'
      send_data @orgaansysteem.vernieuw!
    when 'boezemsystole'
      puts "Boezemsystole"
      @orgaansysteem["Hart"].boezem_systole
      send_data @orgaansysteem.vernieuw!
    when 'kamersystole'
      puts "Kamersystole\n\n"
      @orgaansysteem["Hart"].kamer_systole
      send_data @orgaansysteem.vernieuw!
    end
  end
end

EventMachine::run {
  EventMachine::start_server "127.0.0.1", 8081, OrgaansysteemServer
}