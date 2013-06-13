#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'
import 'lib/tasks/database.rake'

task :default => :all

desc 'Run all specs and features'
task all: [:spec, :'spec:features']

RSpec::Core::RakeTask.new(:spec)

%w{lib models services}.each do |group|
  desc "Run RSpec examples for #{group}"
  RSpec::Core::RakeTask.new(:"spec:#{group}") do |t|
    t.pattern = "spec/#{group}/**/*_spec.rb"
  end
end

Cucumber::Rake::Task.new(:'spec:features') do |t|
  t.cucumber_opts = 'spec/features --format pretty'
end

# vim: syntax=ruby

