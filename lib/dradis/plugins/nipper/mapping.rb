module Dradis::Plugins::Nipper
  module Mapping
    DEFAULT_MAPPING = {
      evidence: {
        'DeviceName' => '{{ nipper[evidence.device_name] }}',
        'DeviceType' => '{{ nipper[evidence.device_type] }}',
        'OS' => '{{ nipper[evidence.device_osversion] }}'
      },
      issue: {
        'Title' => '{{ nipper[issue.title] }}',
        'CVSSv2.Base' => '{{ nipper[issue.cvss_base] }}',
        'CVSSv2.Temporal' => '{{ nipper[issue.cvss_temporal] }}',
        'CVSSv2.Environmental' => '{{ nipper[issue.cvss_environmental] }}',
        'Finding' => '{{ nipper[issue.finding] }}',
        'Impact' => '{{ nipper[issue.impact] }}',
        'Ease' => '{{ nipper[issue.ease] }}',
        'Nipperv1.Ease' => '{{ nipper[issue.nipperv1_ease] }}',
        'Nipperv1.Fix' => '{{ nipper[issue.nipperv1_fix] }}',
        'Nipperv1.Impact' => '{{ nipper[issue.nipperv1_impact] }}',
        'Nipperv1.Rating' => '{{ nipper[issue.nipperv1_rating] }}',
        'Recommendation' => '{{ nipper[issue.recommendation] }}'
      }
    }.freeze

    SOURCE_FIELDS = {
      evidence: [
        'evidence.device_name',
        'evidence.device_type',
        'evidence.device_osversion'
      ],
      issue: [
        'issue.title',
        'issue.cvss_base',
        'issue.cvss_base_vector',
        'issue.cvss_temporal',
        'issue.cvss_temporal_vector',
        'issue.cvss_environmental',
        'issue.cvss_environmental_vector',
        'issue.finding',
        'issue.impact',
        'issue.ease',
        'issue.nipperv1_ease',
        'issue.nipperv1_fix',
        'issue.nipperv1_impact',
        'issue.nipperv1_rating',
        'issue.recommendation'
      ]
    }.freeze
  end
end
