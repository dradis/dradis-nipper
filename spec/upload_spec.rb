require 'spec_helper'

describe 'Nipper upload plugin' do
  describe 'importer' do
    before(:each) do
      # Stub template service
      templates_dir = File.expand_path('../../templates', __FILE__)
      expect_any_instance_of(Dradis::Plugins::TemplateService)
      .to receive(:default_templates_dir).and_return(templates_dir)

      plugin = Dradis::Plugins::Nipper

      @content_service = Dradis::Plugins::ContentService::Base.new(plugin: plugin)

      @importer = plugin::Importer.new(
        content_service: @content_service
      )
    end

    it 'creates an error note when an invalid Nipper XML is uploaded' do
      expect(@content_service).to receive(:create_note) do |args|
        expect(args[:text]).to include('No reports were detected in the uploaded file (/report).')
        OpenStruct.new(args)
      end.once

      @importer.import(file: 'spec/fixtures/files/invalid.xml')
    end

    it 'creates nodes, issues, and evidences as needed' do
      expect(@content_service).to receive(:create_node) do |args|
        expect(args[:label]).to eq('PA-200')
        expect(args[:type]).to eq(:host)
        OpenStruct.new(args)
      end.once
      expect(@content_service).to receive(:create_issue) do |args|
        OpenStruct.new(args)
      end.exactly(2).times
      expect(@content_service).to receive(:create_evidence) do |args|
        OpenStruct.new(args)
      end.exactly(2).times

      # Run the import
      @importer.import(file: 'spec/fixtures/files/sample.xml')
    end
  end
end
