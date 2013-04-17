require "test/unit"
require_relative "../lib/Pipelines"

class TestPipelineList < Test::Unit::TestCase
	def test_dashboard_recieves_list_when_item_added
		fake_dashboard_notifier = FakeDashboardNotifier.new
		pipeline_list = Pipelines.new(fake_dashboard_notifier)
		item1 = {pipeline_name: "A", stage_name: "B", last_build_status: "C"}
		item2 = {pipeline_name: "B", stage_name: "B", last_build_status: "C"}
		expected_list = [item1,item2]
		pipeline_list.add(item1)
		pipeline_list.add(item2)
		assert_equal(expected_list, fake_dashboard_notifier.recieved_list)
	end

	def test_dashboard_recieved_list_when_item_removed
		fake_dashboard_notifier = FakeDashboardNotifier.new
		pipeline_list = Pipelines.new(fake_dashboard_notifier)
		item1 = {pipeline_name: "A", stage_name: "B", last_build_status: "C"}
		item2 = {pipeline_name: "B", stage_name: "B", last_build_status: "C"}
		expected_list = [item1]
		pipeline_list.add(item1)
		pipeline_list.add(item2)
		pipeline_list.remove(item2)
		assert_equal(expected_list, fake_dashboard_notifier.recieved_list)
	end

	def test_dashboard_only_has_one_version_of_a_pipeline_when_last_build_status_changes
		fake_dashboard_notifier = FakeDashboardNotifier.new
		pipeline_list = Pipelines.new(fake_dashboard_notifier)
		item1 = {pipeline_name: "A", stage_name: "B", last_build_status: "C"}
		item2 = {pipeline_name: "A", stage_name: "B", last_build_status: "D"}
		pipeline_list.add(item1)
		pipeline_list.add(item2)
		dashboard_list = fake_dashboard_notifier.recieved_list
		assert_equal(1,dashboard_list.length)
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
