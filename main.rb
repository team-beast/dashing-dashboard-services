require 'sinatra'
require 'httparty'
require 'json'
require_relative "lib/PipelineList"
require_relative "lib/DashboardNotifier"

class PassedNotifier
	def push(list)
		HTTParty.post('http://teambeast.herokuapp.com/widgets/test_passed',
  		:body =>  { auth_token: "YOUR_AUTH_TOKEN",items:list}.to_json)
	end
end


dashboard_notifier = DashboardNotifier.new
passed_notifier = PassedNotifier.new

pipelines = PipelineList.new(dashboard_notifier)
passed_pipelines = PipelineList.new(passed_notifier)

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

	passed_pipelines = PipelineList.new(generate_dashing_object(passed_notifier))
end





def generate_dashing_object(json_object)
	pipeline_name = json_object["label"]
	stage_name =  json_object["value"]
	return {:label => pipeline_name, :value => stage_name}
end
