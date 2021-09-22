module Nipper
  class Evidence
    def initialize(xml_node)
      @xml = xml_node
    end

    def supported_tags
      [ :device_name, :device_osversion, :device_type ]
    end

    def respond_to?(method, include_private = false)
      return true if supported_tags.include?(method.to_sym)
      super
    end

    def method_missing(method, *args)
      unless supported_tags.include?(method)
        super
        return
      end

      field = method.to_s.split('_')[1]
      @xml.at_xpath('./device').attr(field)
    end
  end
end
