
###
# @private
#
# Included in Object to override require functionality.
#
module ::Development::Require
  
  #############
  #  require  #
  #############
  
  ###
  # Overrides default require functionality to include development paths 
  #   instead of gems as specified by configuration file.
  #
  # @param gem_name_or_path
  #
  #        Gem name or path to file.
  #
  # @return [true,false] Whether require loaded gem/file.
  #
  def require( gem_name_or_path )
    
    did_load = ::Development.require( gem_name_or_path )
    
    if did_load.nil?
      did_load = super
    end
    
    return did_load
    
  end
  
end
