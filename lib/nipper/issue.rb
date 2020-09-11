module Nipper
  class Issue
    def initialize(xml_node)
      @xml = xml_node
    end

    def supported_tags
      [
        :title,
        :cvss_base, :cvss_temporal, :cvss_environmental,
        :finding, :impact, :ease, :recommendation
      ]
    end

    def respond_to?(method, include_private=false)
      return true if supported_tags.include?(method.to_sym)
      super
    end

    def method_missing(method, *args)
      unless supported_tags.include?(method)
        super
        return
      end

      if method == :title
        return @xml.attr('title')
      else
        return process_field_value(method)
      end
    end

    def process_field_value(method)
      translations_table = {
        cvss_base: 'issuedetails/ratings/cvssv2-base',
        cvss_temporal: 'issuedetails/ratings/cvssv2-temporal',
        cvss_environmental: 'issuedetails/ratings/cvssv2-environmental',
        finding: 'section[@ref="FINDING"]/text',
        impact: 'section[@ref="IMPACT"]/text',
        ease: 'section[@ref="EASE"]/text',
        recommendation: 'section[@ref="RECOMMENDATION"]/text'
      }

      @xml.xpath("./#{translations_table[method].to_s}").first.try(:text)
    end
  end
end
