require "rspec/core/rake_task"
require "bundler/gem_tasks"

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ["--color"]
end

task :console do
  exec "irb -r namely -I ./lib"
end

task :documentation do
  exec "yardoc --no-private"
end

task default: :spec
