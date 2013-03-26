require 'set'
class PipelineList
	def initialize(dashboard_notifier)
		@list = Set.new []
		@dashboard_notifier = dashboard_notifier
	end

	def add(pipeline)
		@list.add(pipeline)
		@dashboard_notifier.push(@list.to_a)
	end


	def remove(pipeline)
		@list.delete(pipeline)
		@dashboard_notifier.push(@list.to_a)
	end

	def get
		"#{@list.to_a}"
	end
end