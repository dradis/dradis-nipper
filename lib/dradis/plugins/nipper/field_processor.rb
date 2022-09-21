module Dradis
  module Plugins
    module Nipper
      class FieldProcessor < Dradis::Plugins::Upload::FieldProcessor
        ALLOWED_DATA_NAMES = %w{devices section}

        def post_initialize(args = {})
          raise 'Unhandled data name!' unless ALLOWED_DATA_NAMES.include?(data.name)

          @nipper_object = ::Nipper::Issue.new(data)
        end

        def value(args = {})
          field = args[:field]
          _, name = field.split('.')

          @nipper_object.try(name) || 'n/a'
        end
      end
    end
  end
end
