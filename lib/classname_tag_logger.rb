module ClassnameTagLogger

  def self.included(base)
    base.extend(ClassMethods)
    base.tagged_logger_class_name = base.to_s
  end


  module ClassMethods
    def logger
      @tagged_logger ||= TaggedLogger.new(@tagged_logger_class_name)
    end

    def tagged_logger_class_name=(klass_name)
      @tagged_logger_class_name = klass_name
    end
  end




  def logger
    self.class.logger
  end




  class TaggedLogger

    def initialize(klass_name)
      @logger = ActiveSupport::TaggedLogging.new(Rails.logger)
      @klass_name = klass_name
    end

    def fatal(msg, ex = nil)
      log(:fatal, msg, ex)
    end

    def error(msg, ex = nil)
      log(:error, msg, ex)
    end

    def warn(msg, ex = nil)
      log(:warn, msg, ex)
    end

    def info(msg, ex = nil)
      log(:info, msg, ex)
    end

    def debug(msg, ex = nil)
      log(:debug, msg, ex)
    end


    private

    def log(severity, msg, ex = nil)
      @logger.tagged(@klass_name) do
        if ex.is_a? Exception
          @logger.send(severity.to_sym, "#{msg}\n#{ex}: #{ex.backtrace.map {|l| "  " + l }.join("\n")}")
        else
          @logger.send(severity.to_sym, msg)
        end
      end
    end


  end

end
