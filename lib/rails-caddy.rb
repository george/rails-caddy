require 'timecop'
require 'rails-caddy/errors'
require 'rails-caddy/controllers/action_controller_extensions'
require 'rails-caddy/controllers/timecop_controller'
require 'rails-caddy/helpers/rails_caddy_helper'

class RailsCaddy
  
  def self.init!
    @@rails_caddy ||= RailsCaddy.new

    # extend ActionController::Base
    ActionController::Base.send(:include, ActionControllerExtensions)
    
    # Find the controller responsible for establishing session
    @@session_controller = @@rails_caddy.send(:find_session_controller)
	  if @@session_controller.session_options[:key].nil?
      raise SessionUninitializedError, "session does not appear to be established for #{@@session_controller.class}. session: #{@@session_controller.session_options.inspect}"
	  end
	  
	  # Now that we've found the controller responsible for establishing session, we can establish that our 
	  # RailsCaddyController should extend it.  Furthermore, let's extend it with all of the actions we're
	  # going to need to handle
	  c = Class.new(@@session_controller) do
	    include TimecopController
	  end
	  Object.const_set("RailsCaddyController", c)
	  
	  # Now let's add our routes
	  require 'rails-caddy/routes'
	  
    # Lastly, let's add our views to the load path...
    ActionController::Base.append_view_path(File.expand_path(File.join(File.dirname(__FILE__), "rails-caddy", "views")))
  end
  
  private
  
    def initialize
    
    end
    
    def find_session_controller
	    raise SessionControllerNotFoundError, "Cannot find ApplicationController" if !Object.const_defined?(:ApplicationController)
      ApplicationController
    end
  
end

#RailsCaddy.init!