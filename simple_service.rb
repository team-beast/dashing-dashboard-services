require 'sinatra'
require 'httparty'
require 'json'

class PipelineList
	def initialize(dashboard_notifier)
		@list = []
		@dashboard_notifier = dashboard_notifier
	end

	def add(pipeline)
		pipeline_name = pipeline["label"]
		stage_name =  pipeline["value"]
		@list.push({:label => pipeline_name, :value => stage_name})
		@dashboard_notifier.push(@list)
	end

	def remove(pipeline)
		pipeline_name = pipeline["label"]
		stage_name =  pipeline["value"]
		@list.delete({:label => pipeline_name, :value => stage_name})
		@dashboard_notifier.push(@list)
	end

	def get()
		"list: #{@list}"
	end
end


class DashboardNotifier
	def push(list)
		HTTParty.post('http://localhost:3030/widgets/broken_builds_push',
  		:body =>  { auth_token: "TEAM_BEAST_AUTH_TOKEN",items:list}.to_json)
	end
end

dashboard_notifier = DashboardNotifier.new
pipelines = PipelineList.new(dashboard_notifier)

get('/list') { pipelines.get() }


post '/fail' do 
	pipelines_to_add = JSON.parse(request.body.read)["items"]
	pipelines_to_add.each do |pipeline|
		pipelines.add(pipeline)
	end
end

post '/pass' do 
	pipelines_to_add = JSON.parse(request.body.read)["items"]
	pipelines_to_add.each do |pipeline|
		pipelines.remove(pipeline)
	end
end
