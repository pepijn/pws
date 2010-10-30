PROJECT_PATH = File.dirname(__FILE__)

require 'rubygems'
require 'sinatra'
require "sinatra/reloader"

require PROJECT_PATH + '/app.rb'

run Sinatra::Application

disable :logging