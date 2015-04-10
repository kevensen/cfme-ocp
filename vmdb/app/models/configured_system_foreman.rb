class ConfiguredSystemForeman < ConfiguredSystem
  include ProviderObjectMixin

  belongs_to :configuration_profile, :class_name => 'ConfigurationProfileForeman'
  belongs_to :configuration_location
  belongs_to :configuration_organization
  belongs_to :customization_script_medium
  belongs_to :customization_script_ptable
  has_and_belongs_to_many :configuration_tags,
                          :join_table  => 'configuration_tags_configured_systems',
                          :foreign_key => :configured_system_id

  delegate :name, :to => :configuration_location,     :prefix => true, :allow_nil => true
  delegate :name, :to => :configuration_organization, :prefix => true, :allow_nil => true

  def provider_object(connection = nil)
    (connection || connection_source.connect).host(manager_ref)
  end

  def all_tags
    tag_hash = configuration_tags.index_by(&:class)
    configuration_profile ? tag_hash.reverse_merge(configuration_profile.all_tags) : tag_hash
  end

  private

  def connection_source(options = {})
    options[:connection_source] || configuration_manager
  end
end
