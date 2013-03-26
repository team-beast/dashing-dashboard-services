require "test/unit"
require_relative "../lib/PipelineList"

class TestPipelineList < Test::Unit::TestCase
	def test_dashboard_recieves_list_when_item_added
		fake_dashboard_notifier = FakeDashboardNotifier.new
		pipeline_list = PipelineList.new(fake_dashboard_notifier)
		item1 = "A"
		item2 = "B"
		expected_list = [item1,item2]
		pipeline_list.add(item1)
		pipeline_list.add(item2)
		assert_equal(expected_list, fake_dashboard_notifier.recieved_list)
	end

	def test_dashboard_recieved_list_when_item_removed
		fake_dashboard_notifier = FakeDashboardNotifier.new
		pipeline_list = PipelineList.new(fake_dashboard_notifier)
		item1 = "A"
		item2 = "B"
		expected_list = [item1]
		pipeline_list.add(item1)
		pipeline_list.add(item2)
		pipeline_list.remove(item2)
		assert_equal(expected_list, fake_dashboard_notifier.recieved_list)
	end



	def test_dashboard_only_allows_one_version_of_pipeline_in_list
		fake_dashboard_notifier = FakeDashboardNotifier.new
		pipeline_list = PipelineList.new(fake_dashboard_notifier)
		item1 = "A"
		expected_list = [item1]
		pipeline_list.add(item1)
		pipeline_list.add(item1)
		assert_equal(expected_list, fake_dashboard_notifier.recieved_list)
	end
end

class FakeDashboardNotifier
	attr_reader :recieved_list

	def intialize
		recieved_list = []
	end

	def push(list)
		@recieved_list = list
	end
end
