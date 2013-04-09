require 'sinatra'
require 'httparty'
require 'json'
require_relative "lib/PipelineList"
require_relative "lib/DashboardNotifier"

broken_builds_dashboard_notifier = DashboardNotifier.new("broken_builds_push")
building_builds_dashboard_notifier = DashboardNotifier.new("buidling_builds_push")
broken_pipelines = PipelineList.new(broken_builds_dashboard_notifier)
bruilding_pipelines = PipelineList.new(building_builds_dashboard_notifier)


#needs to respond with JSON for keep-alive service.
get('/') do	
	callback = params['callback']
    json = broken_pipelines.get.to_json
    content_type(callback ? :js : :json)
    response = callback ? "#{callback}(#{json})" : json      
    response
end

post '/fail' do 
	pipelines_to_add = JSON.parse(request.body.read)["items"]
	pipelines_to_add.each do |pipeline|
		pipeline_name = pipeline["label"]
		stage_name =  pipeline["value"]
		broken_pipelines.add( generate_dashing_object(pipeline) )
	end
end

post '/pass' do 
	pipelines_to_add = JSON.parse(request.body.read)["items"]
	pipelines_to_add.each do |pipeline|
		broken_pipelines.remove( generate_dashing_object(pipeline) )
		bruilding_pipelines.add( generate_dashing_object(pipeline) )
	end
end

post '/building' do 
	pipelines_to_add = JSON.parse(request.body.read)["items"]
	pipelines_to_add.each do |pipeline|
		broken_pipelines.remove( generate_dashing_object(pipeline) )
	end
end

def generate_dashing_object(json_object)
	pipeline_name = json_object["label"]
	stage_name =  json_object["value"]
	return {:label => pipeline_name, :value => stage_name}
end
