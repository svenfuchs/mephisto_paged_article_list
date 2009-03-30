ENV['RAILS_ENV'] = 'test'
require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment'))
 
require 'test/unit' 
require File.join(File.dirname(__FILE__), '../../mocha/lib/mocha')
require 'action_controller/test_process'
require 'application'
