module Nipper
  class Issue
    def initialize(xml_node)
      @xml = xml_node
    end

    def supported_tags
      [
        :cvss_base, :cvss_base_vector,
        :cvss_environmental, :cvss_environmental_vector,
        :cvss_temporal, :cvss_temporal_vector,
        :ease, :finding, :impact, :recommendation,
        :title
      ]
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
        finding: 'section[@ref="FINDING"]/text',
        impact: 'section[@ref="IMPACT"]/text',
        ease: 'section[@ref="EASE"]/text',
        recommendation: 'section[@ref="RECOMMENDATION"]/text'
      }

      if method == :title
        @xml.attr('title')
      elsif method.to_s.starts_with?('cvss')
        process_cvss_field(method)
      else
        @xml.xpath("./#{translations_table[method]}").first.try(:text)
      end
    end

    def process_cvss_field(method)
      translations_table = {
        cvss_base: 'issuedetails/ratings/cvssv2-base',
        cvss_temporal: 'issuedetails/ratings/cvssv2-temporal',
        cvss_environmental: 'issuedetails/ratings/cvssv2-environmental',
      }

      base_method = method.to_s.sub('_vector', '').to_sym

      if method.to_s.ends_with?('vector')
        @xml.xpath("./#{translations_table[base_method]}").first.try(:text)
      else
        @xml.xpath("./#{translations_table[base_method]}").attr('score')
      end
    end
  end
end
