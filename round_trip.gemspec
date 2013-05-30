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
  s.executables   = `git ls-files bin`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'rake'
  s.add_dependency 'activerecord'
  s.add_dependency 'sqlite3'

  s.add_development_dependency 'bourne'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'json'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-doc'
  s.add_development_dependency 'rspec'

  s.rubyforge_project = 'nowarning'
end

