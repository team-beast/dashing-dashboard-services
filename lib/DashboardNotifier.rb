class DashboardNotifier
	def push(list)
		HTTParty.post('http://http://teambeast.herokuapp.com/widgets/broken_builds_push',
  		:body =>  { auth_token: "YOUR_AUTH_TOKEN",items:list}.to_json)
	end
end