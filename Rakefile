require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

namespace :features do
  Cucumber::Rake::Task.new(:all) do |t|
    t.profile = "default"
  end

  Cucumber::Rake::Task.new(:wip) do |t|
    t.profile = "wip"
  end

  Cucumber::Rake::Task.new(:ok) do |t|
    t.profile = "ok"
  end
end

namespace :spec do
  desc "Run all examples"
  RSpec::Core::RakeTask.new('all')
end
