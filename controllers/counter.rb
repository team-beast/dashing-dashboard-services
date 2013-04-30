require_relative "../lib/DashboardNotifier"
points = []

get %r{/counter/([\w]+)} do | counter_name |
	build_status_notifier = DashboardNotifier.new(counter_name)
	random_number = rand(30)
	point = {:x => points.length, :y => random_number}
	points.push(point)	
	build_status_notifier.push({:points => points})
	# counter_name
end