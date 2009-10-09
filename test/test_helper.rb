ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'rubygems'

class Test::Unit::TestCase
  fixtures :all
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

if Gem.available?('quietbacktrace')
  require 'quietbacktrace'
else
  puts '* quiet backtrace gem not installed'
end

class Test::Unit::TestCase
  # the 'quiet_backtrace' gem provides these:
  if Gem.available?('quietbacktrace')
    self.quiet_backtrace = true  # NOTE: disable this to turn off quietbacktrace
    self.backtrace_silencers << :rails_vendor
    self.backtrace_filters   << :rails_root
  end
end

