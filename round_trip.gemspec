# -*- encoding: utf-8 -*-
$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'round_trip/version'

Gem::Specification.new do |s|
  s.name          = 'round_trip'
  s.summary       = 'Bidirectional sychronisation between Redmine and Trello'
  s.description   = <<-EOT
  RoundTrip keeps a Redmine project and a Trello board aligned.
  Cards are created on Trello to match Redmine issues and vice versa.
  Changes to ticket state on either are also reflected to the other system.
  EOT
  s.version       = RoundTrip::Version::STRING

  s.homepage      = 'http://github.com/joeyates/round_trip'
  s.authors       = ['Joe Yates']
  s.email         = ['joe.g.yates@gmail.com']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files spec`.split("\n")
  s.executables   = `git ls-files bin`.split("\n").map { |p| p[4..-1] }
  s.require_paths = ['lib']

  s.add_dependency 'activerecord', '>= 3.2.0'
  s.add_dependency 'activeresource', '>= 3.2.0'
  s.add_dependency 'highline'
  s.add_dependency 'rake'
  s.add_dependency 'ruby-trello'
  s.add_dependency 'sqlite3'

  s.add_development_dependency 'bourne'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'json'
  s.add_development_dependency 'pry-plus'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'shoulda-matchers'

  s.rubyforge_project = 'nowarning'
end

