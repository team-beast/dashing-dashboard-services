require 'redis'

class RedisWrapper
	def initialize(options = {host_name: "spinyfin.redistogo.com", port:9166, password:"37045748b4fa9b608e7851f215d06d42"})
		@redis =  Redis.new(:host => options[:host_name], :port => options[:port], :password =>  options[:password])
		return self
	end
	def set(options)
		@redis.set(options[:key],options[:value])
	end

	def get(options)
		@redis.get(options[:key])
	end
end