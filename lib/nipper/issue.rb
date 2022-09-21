module Nipper
  class Issue
    def initialize(xml_node)
      @xml = xml_node
    end

    def evidence_tags
      [:device_name, :device_osversion, :device_type, :findings_table]
    end

    def supported_tags
      [
        :cvss_base, :cvss_base_vector,
        :cvss_environmental, :cvss_environmental_vector,
        :cvss_temporal, :cvss_temporal_vector,
        :ease, :finding, :impact, :nipperv1_ease, :nipperv1_fix,
        :nipperv1_impact, :nipperv1_rating,
        :recommendation, :title
      ] + evidence_tags
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

      process_field_value(method)
    end

    def process_field_value(method)
      translations_table = {
        device_name: 'issuedetails/devices/device/@name',
        device_osversion: 'issuedetails/devices/device/@osversion',
        device_type: 'issuedetails/devices/device/@type',
        finding: 'section[@ref="FINDING"]/text',
        impact: 'section[@ref="IMPACT"]/text',
        ease: 'section[@ref="EASE"]/text',
        recommendation: 'section[@ref="RECOMMENDATION"]/text',
      }

      if method == :title
        @xml.attr('title')
      elsif method == :findings_table
        process_findings_table
      elsif method.to_s.starts_with?('cvss')
        process_cvss_field(method)
      elsif method.to_s.starts_with?('nipperv1')
        process_nipperv1_field(method)
      else
        collect_text(@xml.xpath("./#{translations_table[method]}"))
      end
    end

    def process_cvss_field(method)
      translations_table = {
        cvss_base: 'issuedetails/ratings[@type="CVSSv2"]/cvssv2-base',
        cvss_temporal: 'issuedetails/ratings[@type="CVSSv2"]/cvssv2-temporal',
        cvss_environmental: 'issuedetails/ratings[@type="CVSSv2"]/cvssv2-environmental'
      }

      base_method = method.to_s.sub('_vector', '').to_sym

      if method.to_s.ends_with?('vector')
        collect_text(@xml.xpath("./#{translations_table[base_method]}"))
      else
        @xml.xpath("./#{translations_table[base_method]}").attr('score')
      end
    end

    def process_findings_table
      table_xml = @xml.at_xpath('section[@title="Finding"]/table')

      return unless table_xml

      headings = table_xml.xpath('headings/heading').map { |heading| heading.text }
      textile_table = ''
      headings.each do |heading|
        textile_table << "|_. #{heading} "
      end

      textile_table << "|\n"

      tablerows = table_xml.xpath('tablebody/tablerow')
      tablerows.each do |tablerow|
        items = tablerow.xpath('tablecell/item').map { |item| item.text }

        items.each do |item|
          textile_table << "| #{item} "
        end

        textile_table << "|\n"
      end

      textile_table
    end

    def process_nipperv1_field(method)
      translations_table = {
        nipperv1_ease: 'issuedetails/ratings[@type="Nipperv1"]/ease',
        nipperv1_fix: 'issuedetails/ratings[@type="Nipperv1"]/fix',
        nipperv1_impact: 'issuedetails/ratings[@type="Nipperv1"]/impact',
        nipperv1_rating: 'issuedetails/ratings[@type="Nipperv1"]/rating'
      }

      @xml.xpath("./#{translations_table[method]}").text
    end

    private

    def collect_text(xml_field)
      xml_field.children.map { |xml_text| xml_text.text }.join("\n")
    end
  end
end
