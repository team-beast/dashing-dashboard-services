require 'sinatra'
require 'httparty'
require 'json'
require_relative "lib/PipelineList"
require_relative "lib/DashboardNotifier"

dashboard_notifier = DashboardNotifier.new

pipelines = PipelineList.new(dashboard_notifier)

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
		pipeline_name = pipeline["label"]
		stage_name =  pipeline["value"]
		pipelines.add( generate_dashing_object(pipeline) )
	end
end

post '/pass' do 
	pipelines_to_add = JSON.parse(request.body.read)["items"]
	pipelines_to_add.each do |pipeline|
		pipelines.remove( generate_dashing_object(pipeline) )
	end
end

def generate_dashing_object(json_object)
	pipeline_name = json_object["label"]
	stage_name =  json_object["value"]
	return {:label => pipeline_name, :value => stage_name}
end
