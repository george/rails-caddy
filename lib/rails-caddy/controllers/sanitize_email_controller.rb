module SanitizeEmailController
  
  def self.included(base)
    base.class_eval do
      # Make sure we don't reset our own time!
      #skip_filter :handle_timecop_offset
    end
    base.send(:include, Actions)
  end

  module Actions
  
    def set_sanitize_email_address
    
    end
  
    def unset_sanitize_email_address
    
    end
  end
  
  module ActionControllerExtensions
    def self.included(base)
      base.class_eval do
        around_filter :handle_sanitize_email
      end
    end
    
    def handle_sanitize_email
      if session[:sanitize_email_address].nil?
        yield
        return
      end
      
      @original_sanitized_recipients = ActionMailer::Base.sanitized_recipients
      ActionMailer::Base.sanitized_recipients = session[:sanitize_email_address]
      yield
    ensure
      ActionMailer::Base.sanitized_recipients = @original_sanitized_recipients
    end
    
    private :handle_sanitize_email
  end
end