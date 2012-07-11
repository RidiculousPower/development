
###
# Interface for directory implementation. Implementation provided separately for ease of overloading.
#
module ::Development::Directory::DirectoryInterface

  ################
  #  initialize  #
  ################
  
  ###
  #
  # @overload initialize( name, path_part, ... )
  #
  #   @param name
  #
  #          Reference name for directory.
  #   
  #   @param path_part
  #
  #          Part of path; the first can be a symbol referring to a named path or a string,
  #          all other parts must be strings.
  #
  def initialize( name, *path_parts )

    @name = name
        
    self.set_path( *path_parts )
    
    # a directory is also a gemset
    @gemset = ::Development.gemset( name )
    @gemset.set_directory( self )

    # if there's a gem or gemset name by this directory name, 
    # we use it unless gem or gemset already has a directory
    if name
      if gem_instance = ::Development.get_gem( name )
        gem_instance.set_directory( self )
      end

      if gemset_instance = ::Development.get_gemset( name )
        gemset_instance.set_directory( self )
      end
    end
    
  end

  ##########
  #  name  #
  ##########
  
  ###
  # Name.
  #
  # @!attribute [reader] Name.
  #
  attr_reader :name

  #############
  #  members  #
  #############
  
  ###
  # Gems or Gemsets with self as their directory.
  #
  # @return [Array<::Development::Gem,::Development::Gemset>] Members
  #
  def members
    
    return @gemset.members
    
  end
  
  ##########
  #  path  #
  ##########
  
  ###
  # Path.
  #
  # @!attribute [reader] Name.
  #
  attr_reader :path
  
  ##############
  #  set_path  #
  ##############
  
  ###
  # Set Path.
  #
  # @param path
  #
  #        Path string.
  #
  # @return [::Development::Directory] Self.
  #
  def set_path( *path_parts )
    
    if path_parts[ 0 ].is_a?( ::Symbol )
      base_directory_name = path_parts[ 0 ]
      base_directory = ::Development.get_directory( base_directory_name )
      path_parts[ 0 ] = base_directory.path
    end
    
    path_parts.collect!( & :to_s )
    
    if path_parts[ 0 ].nil?
      @path = nil
    else
      @path = ::File.expand_path( ::File.join( *path_parts ) )
    end
    
    return self
    
  end
  
  #########
  #  add  #
  #########
  
  ###
  # Add gems or gemsets to directory.
  #
  # @overload add( gem_or_gemset, ... )
  #
  #   @param gem_or_gemset
  #
  #          Gem or Gemset instance or name to add to directory.
  #
  # @return [::Development::Directory] Self.
  #
  def add( *gems_or_gemsets )
    
    @gemset.add( *gems_or_gemsets )

    return self
    
  end

  ############
  #  delete  #
  #  remove  #
  ############
  
  ###
  # Remove gems or gemsets from directory.
  #
  # @overload delete( gem_or_gemset, ... )
  #
  #   @param gem_or_gemset
  #
  #          Gem or Gemset instance or name to add to directory.
  #
  # @return [::Development::Directory] Self.
  #
  def delete( *gems_or_gemsets )
    
    return @gemset.delete( *gems_or_gemsets )
    
  end
  
  alias_method :remove, :delete

end
