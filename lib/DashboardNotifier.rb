require_relative '../Configuration'

class DashboardNotifier
	def initialize(widget_id)
		@widget_id = widget_id
	end
	def push(list)		
		HTTParty.post("#{Configuration::DASHBOARD_URL}/widgets/#{@widget_id}",
  		:body =>  { auth_token: "YOUR_AUTH_TOKEN",items:list}.to_json)
	end
end