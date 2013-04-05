module AppConfig

  class << self

    MEMCACHE_KEY__CFG_LAST_LOAD_TIMESTAMP = 'appcfg-last-load-timestamp'

    def load_config()
      @@config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join('config', 'appconfig.yml'))[Rails.env])
      Rails.logger.info 'App config (re)loaded.'
    end


    def config
      AppConfig.load_config if @@config.nil?
      return @@config
    end

    def [](key)
      AppConfig.load_config if @@config.nil?
      return @@config[key]
    end


    private

    @@config = nil


  end

end


AppConfig.load_config
