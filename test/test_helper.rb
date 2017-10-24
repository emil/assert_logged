require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'log_capture'
require 'minitest/unit'
require 'mocha/mini_test'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add LogCapture Assertions
  include LogCapture::Assertions
end
