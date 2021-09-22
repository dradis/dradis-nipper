module Dradis::Plugins::Nipper
  class Importer < Dradis::Plugins::Upload::Importer
    SECURITY_SECTIONS = %w{
      SECURITY.INTRODUCTION
      SECURITY.CONCLUSIONS
      SECURITY.RECOMMENDATIONS
      SECURITY.MITIGATIONS
      SECURITY.CLASSIFICATIONS
    }

    def import(params = {})
      file_content = File.read(params[:file])

      logger.info { 'Parsing Nipper output file...' }
      doc = Nokogiri::XML(file_content)
      logger.info { 'Done.' }

      if doc.xpath('//document[@nipperstudio]').empty?
        error = 'No reports were detected in the uploaded file (/report). '\
        'Ensure you uploaded a Nipper XML report.'

        logger.fatal { error }
        content_service.create_note text: error

        return false
      end

      doc.xpath('//document[@nipperstudio]').each do |root|
        logger.info { 'Processing report...' }

        process_node(root)

        root.xpath('./report/part[@ref="SECURITYAUDIT"]/section').each do |report|
          next if SECURITY_SECTIONS.include?(report.attr('ref'))

          process_issue(report)
        end

        logger.info { 'Report processed...' }
      end

      true
    end

    private

    def process_evidence(xml_evidence, issue)
      logger.info { 'Creating evidence...' }

      evidence_text = template_service.process_template(template: 'evidence', data: xml_evidence)
      content_service.create_evidence(issue: issue, node: @host_node, content: evidence_text)
    end

    def process_issue(xml_issue)
      plugin_id = xml_issue.attr('ref')

      logger.info { "Creating issue: #{plugin_id}" }

      issue_text = template_service.process_template(template: 'issue', data: xml_issue)
      issue = content_service.create_issue(text: issue_text, id: plugin_id)

      xml_evidence = xml_issue.at_xpath('./issuedetails/devices')
      process_evidence(xml_evidence, issue)
    end

    def process_node(xml_root)
      logger.info { 'Creating node...' }

      # Create host node
      host_xml = xml_root.at_xpath('./information/devices/device')
      @host_node = content_service.create_node(
        label: host_xml.attr('name'),
        type: :host
      )

      # Set device properties
      @host_node.set_property(:device_name, host_xml.attr('name'))
      @host_node.set_property(:device_type, host_xml.attr('type'))
      @host_node.set_property(:os_version, host_xml.attr('osversion'))
      @host_node.save
    end
  end
end
