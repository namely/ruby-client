require "rspec/core/rake_task"
require "bundler/gem_tasks"

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ["--color"]
end

task default: :spec
