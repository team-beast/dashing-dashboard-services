require 'test/unit'
require 'json'

class TestCounterRepository < Test::Unit::TestCase
	def test_that_counters_retrieved_by_counter_name
		counter_name = "jimmy"
		mock_redis_wrapper = MockRedisWrapper.new({})
		Counter::CounterValuesRepository.new(counter_name, mock_redis_wrapper).get
		assert_equal("counter/#{counter_name}", mock_redis_wrapper.get_data[:key])
	end
	
	def test_that_when_redis_contains_counter_entries_in_json_Then_result_is_converted_to_hash
		counter_entries = [{:x => 1, :y => 101}, {:x => 22, :y => 45}]
		mock_redis_wrapper = MockRedisWrapper.new(get_result: counter_entries.to_json)
		result = Counter::CounterValuesRepository.new("", mock_redis_wrapper).get		
		assert_equal(counter_entries, result)
	end

	def test_that_when_redis_contains_no_counter_entries_in_json_Then_result_is_empty		
		mock_redis_wrapper = MockRedisWrapper.new({})
		result = Counter::CounterValuesRepository.new("", mock_redis_wrapper).get		
		assert_equal([], result)
	end

	def test_that_when_counter_values_retrieved_twice_Then_redis_called_once		
		mock_redis_wrapper = MockRedisWrapper.new({})
		counter_values_repository = Counter::CounterValuesRepository.new("", mock_redis_wrapper)
		counter_values_repository.get
		counter_values_repository.get
		assert_equal(1, mock_redis_wrapper.get_calls)
	end

	def test_when_counter_values_retrieved_twice_Then_second_call_returns_correct_counter_entries
		counter_entries = [{:x => 10, :y => 1000}]
		mock_redis_wrapper = MockRedisWrapper.new(get_result: counter_entries.to_json)
		counter_values_repository = Counter::CounterValuesRepository.new("", mock_redis_wrapper)
		counter_values_repository.get
		result_of_second_call = counter_values_repository.get
		assert_equal(counter_entries, result_of_second_call)
	end

	def test_that_counters_are_added_by_counter_name
		counter_name = "Bill"
		mock_redis_wrapper = MockRedisWrapper.new({})
		Counter::CounterValuesRepository.new(counter_name, mock_redis_wrapper).add
		assert_equal("counter/#{counter_name}", mock_redis_wrapper.set_data[:key])
	end
end

class MockRedisWrapper
	attr_reader :get_data, :get_calls, :set_data

	def initialize(options)
		@get_result = options[:get_result]
		@get_calls = 0
	end

	def get(options)
		@get_calls+=1
		@get_data = options		
		@get_result
	end

	def set(options)
		@set_data = options
	end
end























module Counter
	class CounterValuesRepository
		COUNTER_KEY_PREFIX = 'counter'

		def initialize(counter_name, redis_wrapper)						
			@repository_key = "#{COUNTER_KEY_PREFIX}/#{counter_name}"			
			@redis_wrapper = redis_wrapper
			redis_counter_value = @redis_wrapper.get(key: @repository_key)
			@counter_values = CounterValuesSerializer.new.deserialize(redis_counter_value)			
		end

		def get
			@counter_values
		end

		def add
			@redis_wrapper.set(key: @repository_key)
		end
	end

	class CounterValuesSerializer
		def deserialize(redis_counter_result)
			return [] if redis_counter_result.nil?				
			JSON.parse(redis_counter_result, :symbolize_names => true)						
		end
	end
end

