task :default => [:dependencies, :ruby_tests, :commit, :deploy]

task :dependencies do
	sh "bundle install"
end

task :ruby_tests do
	require 'peach'
	Dir["./Tests/**/*.rb"].peach do | file |
		sh "ruby #{file}"
	end
end

task :commit do
	puts "Committing and Pushing to Git"
	require 'git_repository'
	commit_message = ENV["m"] || 'no commit message'
	git = GitRepository.new
	git.add
	git.commit(:message => 'dashboard_commit')
	git.push	
end

task :deploy do
	puts "Deploying to heroku"
	require 'git_repository'
	git = GitRepository.new(:remote => "heroku")
	git.push
end
