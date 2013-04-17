require 'sinatra'
require 'httparty'
require 'json'
require_relative "lib/Pipelines"
require_relative "lib/DashboardNotifier"

build_status_notifier = DashboardNotifier.new("build_status")
pipelines = Pipelines.new(build_status_notifier)


#needs to respond with JSON for keep-alive service.
get('/') do	
	callback = params['callback']
    json = pipelines.get.to_json
    content_type(callback ? :js : :json)
    response = callback ? "#{callback}(#{json})" : json      
    response
end

post '/fail' do 
	pipelines_to_add = JSON.parse(request.body.read)["items"]
	pipelines_to_add.each do |pipeline|
		pipelines.add( generate_dashing_object(pipeline) )
	end
end

post '/pass' do 
	pipelines_to_add = JSON.parse(request.body.read)["items"]
	pipelines_to_add.each do |pipeline|
		pipelines.remove( generate_dashing_object(pipeline) )
	end
end

post '/building' do 
	pipelines_to_add = JSON.parse(request.body.read)["items"]
	pipelines_to_add.each do |pipeline|
		pipelines.add( generate_dashing_object(pipeline) )
	end
end

def generate_dashing_object(json_object)	
	pipeline_name = json_object["title"]
	stage_name =  json_object["stage"]
	last_build_status = json_object["last_build_status"]
	return {:pipeline_name => pipeline_name, :stage_name => stage_name, :status =>last_build_status}
end
