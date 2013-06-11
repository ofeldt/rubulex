require 'rubygems'
require 'bundler'

ENV['BUNDLE_GEMFILE'] ||= File.join(File.dirname(__FILE__), "Gemfile")
ENV['RACK_ENV'] ||= "testing"
Bundler.require(:default, ENV['RACK_ENV'])

require 'rubulex'

run Rubulex::App
