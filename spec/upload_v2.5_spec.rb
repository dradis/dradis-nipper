require 'rails_helper'

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

    context 'nipper v2.5 output' do
      it 'imports Nipperv1 fields and findings table' do
        expect(@content_service).to receive(:create_node) do |args|
          expect(args[:label]).to eq('PA-200')
          expect(args[:type]).to eq(:host)
          @node = Node.create(label: args[:label])
        end.once
        expect(@content_service).to receive(:create_issue) do |args|
          OpenStruct.new(args)
          @issue = Issue.create(text: args[:text])
        end.exactly(1).times
        expect(@content_service).to receive(:create_evidence) do |args|
          OpenStruct.new(args)
        end.exactly(1).times

        @importer.import(file: File.expand_path('../spec/fixtures/files/sample_v2.5.xml', __dir__))

        expect(@issue.fields['Nipperv1.Ease']).to eq('Moderate')
        expect(@issue.fields['Nipperv1.Fix']).to eq('Quick')
        expect(@issue.fields['Nipperv1.Impact']).to eq('Critical')
        expect(@issue.fields['Nipperv1.Rating']).to eq('High')
      end
    end
  end
end
