module Nipper
  class Evidence
    def initialize(xml_node)
      @xml = xml_node
    end

    def supported_tags
      [ :device_name, :device_osversion, :device_type, :findings_table ]
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

      if method == 'findings_table'.to_sym
        process_findings_table
      else
        field = method.to_s.split('_')[1]

        @xml.at_xpath('./device').attr(field)
      end
    end

    def process_findings_table
      headings = @xml.xpath('./table/headings/heading').map { |heading| heading.text }

      return if headings.blank?

      textile_table = ''
      headings.each do |heading|
        textile_table << "|_. #{heading} "
      end

      textile_table << "|\n"

      tablerows = @xml.xpath('./table/tablebody/tablerow')
      tablerows.each do |tablerow|
        items = tablerow.xpath('./tablecell/item').map { |item| item.text }

        items.each do |item|
          textile_table << "| #{item} "
        end

        textile_table << "|\n"
      end

      textile_table
    end
  end
end
