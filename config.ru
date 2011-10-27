require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require './jwcnu.rb'

run Sinatra::Application