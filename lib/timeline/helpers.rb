require 'multi_json/version'

module Timeline

  def self.get_global_activity(limit = 20)
    ::Timeline.get_list({list_name: "global:activity", start: 0, end: limit }).map do |item|
      ::Timeline::Activity.new ::Timeline.decode(item)
    end
  end
  # module_function :get_global_activity

  module Helpers
    class DecodeException < StandardError; end

    def encode(object)
      if ::MultiJson::VERSION.to_f > 1.3
        ::MultiJson.dump(object)
      else
        ::MultiJson.encode(object)
      end
    end

    def decode(object)
      return unless object

      begin
        if ::MultiJson::VERSION.to_f > 1.3
          ::MultiJson.load(object)
        else
          ::MultiJson.decode(object)
        end
      rescue ::MultiJson::DecodeError => e
        raise DecodeException, e
      end
    end

    def get_list(options={})
      keys = Timeline.redis.lrange options[:list_name], options[:start], options[:end]
      return [] if keys.blank?
      items = Timeline.redis.mget(*keys)
      items.delete(nil)
      items
    end
  end
end
