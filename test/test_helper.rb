require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    include ApplicationHelper

    def log_in_as user
      session[:user_id] = user.id
    end
  end
end

module ActionDispatch
  class IntegrationTest
    # Log in as a particular user.
    def log_in_as user, password: t(:pass), remember_me: Settings.one.to_s
      post login_path, params: {session: {email: user.email,
                                          password: password,
                                          remember_me: remember_me}}
    end
  end
end
