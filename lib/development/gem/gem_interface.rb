
###
# Interface for gem implementation. Implementation provided separately for ease of overloading.
#
module ::Development::Gem::GemInterface

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
  #   @param directory_or_path
  #
  #          Development::Directory instance or String describing path.
  #
  def initialize( name, directory_or_path = nil )

    gem_reference_name = name.to_s.gsub( '/', '-' )
    
    @name = gem_reference_name.to_sym

    self.set_directory( directory_or_path )
    
    @enabled = false
    
    # if there's a directory by gem name, use it
    if directory = ::Development.get_directory( name )
      @directory = directory
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

  ###############
  #  directory  #
  ###############
  
  ###
  # Directory.
  #
  # @overload directory
  #
  # @overload directory( directory_name )
  #
  #    @param directory_name
  #
  #           Name of directory.
  #
  # @overload directory( directory_path_part, ... )
  #
  #   @param directory_path_part
  #
  #          The first part can be a symbol naming a directory; all parts can be String path parts.
  #
  # @return [::Development::Directory] Directory instance.
  #
  def directory( *args )
    
    return_value = nil
    
    if args.empty?
      return_value = @directory
    else
      @directory = ::Development.directory( *args )
      return_value = @directory
    end
    
    return return_value
    
  end

  ###################
  #  set_directory  #
  ###################
  
  ###
  # Directory.
  #
  # @!attribute [reader] Directory.
  #
  # @return [::Development::Gem] Self.
  #
  def set_directory( directory_or_path )

    if directory_or_path
      
      case directory_or_path
        when ::Development::Directory
          @directory = directory_or_path
        else
          unless @directory = ::Development.get_directory( directory_or_path )
            if @directory
              @directory.set_path( directory_or_path )
            else
              @directory = ::Development::Directory.new( @name, directory_or_path )
            end
          end
      end
      
    else
      
      @directory = nil
      
    end

    return self

  end
  
  ##############
  #  enabled?  #
  ##############
  
  ###
  # Query whether Gem is enabled.
  #
  # @return [true,false] Whether Gem is enabled.
  #
  def enabled?
    
    return @enabled
    
  end
  
  ###############
  #  disabled?  #
  ###############

  ###
  # Query whether Gem is disabled.
  #
  # @return [true,false] Whether Gem is disabled.
  #
  def disabled?

    return ! @enabled
    
  end

  #############
  #  enable!  #
  #############
  
  ###
  # Enable all gems and general load path searching.
  #
  # @return [::Development::Gem] Self.
  #
  def enable!
    
    @enabled = true
    
    return self
    
  end
  
  ##############
  #  disable!  #
  ##############

  ###
  # Disble all gems and general load path searching.
  #
  # @return [::Development::Gem] Self.
  #
  def disable!

    @enabled = false
    
    return self
    
  end
  
end
