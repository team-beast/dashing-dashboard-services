require_relative '../Configuration'

class DashboardNotifier
	def initialize(widget_id)
		@widget_id = widget_id
	end
	def push(request_body)		
		request_body[:auth_token] = "YOUR_AUTH_TOKEN"
		HTTParty.post("#{Configuration::DASHBOARD_URL}/widgets/#{@widget_id}",
  		:body =>  request_body.to_json)
	end
end