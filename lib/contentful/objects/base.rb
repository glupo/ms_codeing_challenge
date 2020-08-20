module Contentful
  module Objects
    class Base
      def initialize(entry)
        raise "Cannot create empty object" if entry.nil?

        @entry = entry
      end

      def id
        entry.id
      end

      private

      attr_reader :entry

      def get_value(key)
        value = entry.fields[key]

        case value
        when Contentful::Entry
          build_object(value)
        when Contentful::Link
          build_object(value.resolve(client))
        when Contentful::Array, Array
          value.map { |element| get_value(element) }
        else
          value
        end
      end

      def build_object(entry)
        type = entry.content_type.id
        object_class = safe_constantize("Contentful::Objects::#{type}")
        object_class.new(entry)
      rescue NameError
        entry
      end

      class << self
        def content_type
          self.name.demodulize.underscore.to_sym
        end

        def inherited(subclass)
          subclass.instance_variable_set(:@fields, fields.dup)
        end

        def field(name, default: nil)
          @fields.add(name)

          define_method(name) do
            get_value(name) || default
          end
        end

        def fields
          @fields ||= Set.new
        end

        def load(limit: 10, offset: 0)
          client.entries(content_type: content_type, limit: limit, skip: offset).
            map do |entry|
              self.new(entry)
            end
        end

        def find(id)
          entry = client.entries(content_type: content_type, 'sys.id' => id).first
          return entry if entry.nil?
          self.new(entry)
        end

        def client
          @client ||= Contentful::Client.new(
            access_token: Rails.application.credentials.contentful[:access_token],
            space: Rails.application.credentials.contentful[:space_id],
          )
        end
      end
    end
  end
end
