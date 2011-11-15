module BigBlueButtonAPITests

  # Test object that stores information about an API request
  class APIRequest
    attr_accessor :opts       # options hash
    attr_accessor :id         # meetind id
    attr_accessor :mod_pass   # moderator password
    attr_accessor :name       # meeting name
    attr_accessor :method     # last api method called
    attr_accessor :response   # last api response
    attr_accessor :exception  # last exception
  end

  # Global configurations
  module Configs
    class << self
      attr_accessor :cfg           # configuration file
      attr_accessor :cfg_server    # shortcut to the choosen server configs
      attr_accessor :req           # api request

      def initialize_cfg
        config_file = File.join(File.dirname(__FILE__), '..', '..', 'config.yml')
        unless File.exist? config_file
          throw Exception.new(config_file + " does not exists. Copy the example and configure your server.")
        end
        config = YAML.load_file(config_file)
        config
      end

      def initialize_cfg_server
        if ENV['SERVER']
          unless self.cfg['servers'].has_key?(ENV['SERVER'])
            throw Exception.new("Server #{ENV['SERVER']} does not exists in your configuration file.")
          end
          srv = self.cfg['servers'][ENV['SERVER']]
        else
          srv = self.cfg['servers'][self.cfg['servers'].keys.first]
        end
        srv['bbb_version'] = '0.7' unless srv.has_key?('bbb_version')
        srv
      end

    end

    self.cfg = initialize_cfg
    self.cfg_server = initialize_cfg_server
    self.req = BigBlueButtonAPITests::APIRequest.new
  end
end
