module Dradis
  module Plugins
    module Nipper
      class Engine < ::Rails::Engine
        isolate_namespace Dradis::Plugins::Nipper

        include ::Dradis::Plugins::Base
        description 'Processes Nipper XML format'
        provides :upload
      end
    end
  end
end
