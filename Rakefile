#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'
import 'lib/tasks/database.rake'

task :default => :spec

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:'spec:features') do |t|
  t.cucumber_opts = 'spec/features --format pretty'
end

# vim: syntax=ruby

