require 'set'
require_relative 'PipelineSet'

class Pipelines
	def initialize(dashboard_notifier)
		@list = PipelineSet.new
		@dashboard_notifier = dashboard_notifier
	end

	def add(pipeline)
		@list.add(pipeline)
		@dashboard_notifier.push({:items => @list.to_a})
	end


	def remove(pipeline)
		@list.remove(pipeline)
		@dashboard_notifier.push({:items => @list.to_a})
	end

	def get
		"#{@list.to_a}"
	end
end

