require_relative "../lib/DashboardNotifier"
points = []

post %r{/counter/([\w]+)} do | counter_name |
	counter_value = JSON.parse(request.body.read)["counter"]
	counter_notifier = DashboardNotifier.new(counter_name)	
	points.push(counter_value)	
	counter_notifier.push({:points => points})	
end