class PipelineSet
	def initialize
		@list = []
	end

	def add(pipeline)
		remove(pipeline)
		@list.push(pipeline)
	end

	def remove(pipeline)
		@list.delete_if do |pipeline_item|
			are_same?(pipeline_item,pipeline)
		end	
	end

	def to_a
		@list
	end

	private 

	def are_same?(pipeline_one, pipeline_two)
		(pipeline_one[:stage_name] == pipeline_two[:stage_name]) && (pipeline_one[:pipeline_name] == pipeline_two[:pipeline_name])
	end
end