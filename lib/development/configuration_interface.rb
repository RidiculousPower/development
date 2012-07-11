
###
# @private
#
# Interface with Object instance methods for use from configuration file since
#   load cannot load into a context line by line.
#
module ::Development::ConfigurationInterface
  
  ################
  #  gem_method  #
  ################
  
  ###
  # Define a gem or retrieve defined gem.
  #
  # @param name
  #
  #        Name of gem.
  #
  # @param directory_or_path
  #
  #        Development::Directory or String describing path.
  #
  # @return [::Development::Gem]
  #
  def gem_method( name, directory_or_path = nil )
    return ::Development.gem( name, directory_or_path )
  end
  
  ############
  #  gemset  #
  ############

  ###
  # Define a gem or retrieve defined gem.
  #
  # @overload self.gemset( name, gem_or_gemset, ... )
  #
  #   @param name
  #   
  #          Name of gemset.
  #
  #   @param gem_or_gemset
  #
  #          Gem or Gemset name or instance.
  #
  # @return [::Development::Gemset]
  #
  def gemset( name, *gems_or_gemsets )
    return ::Development.gemset( name, *gems_or_gemsets )
  end

  ###############
  #  directory  #
  ###############
  
  ###
  # Return path for directory name.
  #
  # @overload self.directory( name, path, gem_or_gemset, ... )
  #
  #   @param directory_name
  #   
  #          Name of named directory.
  #   
  #   @param path
  #   
  #          String describing directory path.
  #
  #   @param gem_or_gemset
  #   
  #          Gem or Gemset or String or Symbol describing Gem or Gemset.
  #
  # @return [::Development::Directory] Directory.
  #
  def directory( name, *path_parts )
    return ::Development.directory( name, *path_parts )
  end

  #############
  #  enable!  #
  #############
  
  ###
  # Enable gems.
  #
  # @overload enable!
  #
  # @overload enable( gem_or_gemset, ... )
  #
  #   @param gem_or_gemset 
  #
  #          Gem or Gemset instance or name to enable.
  #
  # @return [::Development] Self. 
  #
  def enable!( *gem_or_gemset_names )
    return ::Development.enable!( *gem_or_gemset_names )
  end

  ##############
  #  disable!  #
  ##############

  ###
  # Disable gems.
  #
  # @overload disable!
  #
  # @overload disable( gem_or_gemset, ... )
  #
  #   @param gem_or_gemset 
  #
  #          Gem or Gemset instance or name to disable.
  #
  # @return [::Development] Self. 
  #
  def disable!( *gem_or_gemset_names )
    return ::Development.disable!( *gem_or_gemset_names )
  end

end
