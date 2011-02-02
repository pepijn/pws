task :default => :build

desc "Build and watch project from src/*.coffee to lib/*.js"
task :build do
  sh "coffee --watch --bare -o lib/ -c src/"
end