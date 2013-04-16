module Configuration
	DASHBOARD_URL = ENV['RACK_ENV'] == "production" ? "http://teambeast.herokuapp.com" : "http://127.0.0.1:3030"
end