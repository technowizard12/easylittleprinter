# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "easylittleprinter"
  gem.homepage = "http://github.com/technowizard12/easylittleprinter"
  gem.license = "MIT"
  gem.summary = "Little Printer Publication in a Box"
  gem.description = "Serves static images from a remote server on the dates assigned in their filenames to BERG Cloud"
  gem.email = "simon@simonorrstudio.com"
  gem.authors = ["Simon Orr"]
  gem.add_dependency "camping"
  gem.add_dependency "markaby"
  gem.add_dependency "builder"
  gem.add_dependency "rack"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end


require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "easylittleprinter #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
