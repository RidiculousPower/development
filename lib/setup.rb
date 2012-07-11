
###
# Object is enabled with Development require functionality.
#
class ::Object
  include ::Development::Require
  extend ::Development::Require
  include ::Development::ConfigurationInterface
end

if defined?( ::Bundler )
  ::Development::Require::BundlerSupport.call
end

::Development.load_configuration_file( ::File.join( '~', ::Development::ConfigurationFileName ) )
