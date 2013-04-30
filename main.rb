require 'sinatra'
require 'httparty'
require 'json'
require_relative "lib/Pipelines"
require_relative "lib/DashboardNotifier"
require_relative "controllers/counter"
require_relative "controllers/pipelines"