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
  end
end
