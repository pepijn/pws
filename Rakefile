task :default => :build

desc "Build and watch project from src/*.coffee to lib/*.js"
task :build do
  sh "coffee --watch --bare -o lib/ -c src/"
end

desc "Export GitHub commits to CSV file"
task :export_commits do
  require 'json'
  require 'net/http'
  require 'date'

  File.open('tmp/commits.csv', 'w') do |f|
    body = Net::HTTP.get 'github.com', '/api/v2/json/commits/list/pepijn/pws/master?page=N'
    json = JSON.parse body

    json["commits"].each do |c|
      d = DateTime.parse(c['committed_date'])

      f << "\"#{[d.day, d.month, d.year].join('-')}\";\"#{c['message']}\"\n"
    end
  end
end