require 'cucumber'
require 'cucumber/rake/task'
require 'spec/rake/spectask'

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
  Spec::Rake::SpecTask.new('all') do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
  end
end
