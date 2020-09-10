require_relative 'gem_version'

module Dradis
  module Plugins
    module Nipper
      def self.version
        gem_version
      end
    end
  end
end
