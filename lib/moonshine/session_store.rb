module Moonshine
  module SessionStore

    # Define options for this plugin in your moonshine.yml
    #
    #   :session_key: 'deadbeef123456789....'
    #
    # Then include the plugin and call the recipe(s) you need:
    #
    #  recipe :session_store
    def session_store
      session_store_config = <<-CONFIG
      ActionController::Base.session = {
        :session_key => '_#{configuration[:application]}_session',
        :secret => '#{configuration[:session_key]}'
      }
      CONFIG

      file("#{rails_root}/config/initializers/session_store.rb",
           :ensure => :present,
           :content => session_store_config,
           :before => exec('rake tasks'))
    end
    
    # Helper, since Rails' version isn't loading in time
    def moonshine_stringify_keys(h)
      h.inject({}) do |options, (key, value)|
        options[key.to_s] = value
        options
      end
    end

  end
end
