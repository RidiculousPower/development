
###
# Interface for gemset implementation. Implementation provided separately for ease of overloading.
#
module ::Development::Gemset::GemsetInterface
  
  ################
  #  initialize  #
  ################
  
  def initialize( name, *gems_or_gemsets )
    
    gem_reference_name = name.to_s.gsub( '/', '-' )
    
    @name = gem_reference_name.to_sym
    
    @gems_or_gemsets = { }
    
    add( *gems_or_gemsets )
    
    @enabled = false
    
    # if there's a directory by gemset name, use it
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

  #############
  #  members  #
  #############
  
  ###
  # Gems or Gemsets that are members of self.
  #
  # @return [Array<::Development::Gem,::Development::Gemset>] Members
  #
  def members
    
    return @gems_or_gemsets.keys
    
  end
  
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
  def set_directory( directory_or_path, *path_parts )

    if directory_or_path
      
      case directory_or_path
        when ::Development::Directory
          @directory = directory_or_path
        else
          if path_parts.empty?
            @directory = ::Development.get_directory( directory_or_path )
          else
            @directory ||= ::Development.directory( @name )
            @directory.set_path( directory_or_path, *path_parts )
          end
      end

      @gems_or_gemsets.each do |this_gem_or_gemset, true_value|
        this_gem_or_gemset.set_directory( @directory )
      end
      
    else
      
      @directory = nil
      
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
  # @return [::Development::Gemset] Self.
  #
  def add( *gems_or_gemsets )
    
    gems_or_gemsets.each do |this_gem_or_gemset|
      
      found_gem_or_gemset = false

      case this_gem_or_gemset
        
        when ::Development::Gem, 
             ::Development::Gemset
          
          @gems_or_gemsets[ this_gem_or_gemset ] = true
          
        else
          
          this_gem_or_gemset_reference_name = this_gem_or_gemset.to_s.gsub( '/', '-' )

          if gemset_instance = ::Development.get_gemset( this_gem_or_gemset_reference_name )
            gemset_instance.set_directory( @directory )
            @gems_or_gemsets[ gemset_instance ] = true
            found_gem_or_gemset = true
          end

          if gem_instance = ::Development.get_gem( this_gem_or_gemset_reference_name )
            gem_instance.set_directory( @directory )
            @gems_or_gemsets[ gem_instance ] = true
            found_gem_or_gemset = true
          end

          unless found_gem_or_gemset
            gem_instance = ::Development.gem( this_gem_or_gemset_reference_name )
            gem_instance.set_directory( @directory )
            @gems_or_gemsets[ gem_instance ] = true
          end

      end
      
    end
    
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
  # @return [::Development::Gemset] Self.
  #
  def delete( *gems_or_gemsets )
    
    gems_or_gemsets.each do |this_gem_or_gemset|
      
      case this_gem_or_gemset
        
        when ::Development::Gem, 
             ::Development::Gemset

          @gems_or_gemsets.delete( this_gem_or_gemset )
        
        else
        
          this_gem_or_gemset_reference_name = this_gem_or_gemset.to_s.gsub( '/', '-' )
        
          if gemset_instance = ::Development.get_gemset( this_gem_or_gemset_reference_name )
            @gems_or_gemsets.delete( gemset_instance )
          end

          if gem_instance = ::Development.get_gem( this_gem_or_gemset_reference_name )
            @gems_or_gemsets.delete( gem_instance )
          end
        
      end
      
    end
    
    return self
    
  end
  
  alias_method :remove, :delete

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
    
    @gems_or_gemsets.each do |this_gem_or_gemset, true_value|
      this_gem_or_gemset.enable!
    end
    
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
    
    @gems_or_gemsets.each do |this_gem_or_gemset, true_value|
      this_gem_or_gemset.disable!
    end
    
    return self
    
  end
  
end
