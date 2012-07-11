
# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

###
# Singleton that manages configurations and requires.
#
module ::Development

  ###
  # Name of configuration file: .development.rb.
  #
  ConfigurationFileName = '.development.rb'

  #####################
  #  self.initialize  #
  #####################
  
  ###
  # Initialize internal tracking variables.
  #
  # @return [Development] Self.
  #
  def self.initialize

    @enable_for_all = false
    
    @directories = { }
    
    @gems = { }
    @gemsets = { }

    @general_load_paths = [ ]

    @loaded_gems = { }

    return self
    
  end

  ################
  #  self.clear  #
  ################
  
  ###
  # Reset internal tracking variables.
  #
  # @return [Development] Self.
  #
  def self.clear
    
    @enable_for_all = false

    @directories.clear

    @gems.clear
    @gemsets.clear

    @general_load_paths.clear

    @loaded_gems.clear
    
    return self
    
  end

  ##############
  #  self.gem  #
  ##############
  
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
  def self.gem( name, directory_or_path = nil )

    gem_require_name = name.to_s.gsub( '/', '-' )

    name = gem_require_name.to_sym

    if gem_instance = @gems[ name ]
      if directory_or_path
        gem_instance.set_directory( directory_or_path )
      end
    else
      @gems[ name ] = gem_instance = Gem.new( name, directory_or_path )
    end
    
    return gem_instance

  end
  
  ##################
  #  self.get_gem  #
  ##################
  
  ###
  # Retrieve defined gem.
  #
  # @param name
  #
  #        Name of gem.
  #
  # @return [::Development::Gem]
  #
  def self.get_gem( name )
    
    return @gems[ name.to_sym ]
    
  end
  
  ###############
  #  self.gems  #
  ###############
  
  ###
  # Get hash of gems.
  #
  # @return [Hash{Symbol=>Array<::Development::Gem>}] Hash of gemsets and their gem or gemset members.
  #
  def self.gems
    
    return @gems
    
  end

  #################
  #  self.gemset  #
  #################
  
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
  def self.gemset( name, *gems_or_gemsets )

    name = name.to_sym
    
    unless gemset_instance = @gemsets[ name ]
      @gemsets[ name ] = gemset_instance = Gemset.new( name )
    end
    
    gemset_instance.add( *gems_or_gemsets )
    
    return gemset_instance
    
  end
  
  #####################
  #  self.get_gemset  #
  #####################
  
  ###
  # Retrieve defined gemset.
  #
  # @param name
  #
  #        Name of gemset.
  #
  # @return [::Development::Gemset]
  #
  def self.get_gemset( name )
    
    return @gemsets[ name.to_sym ]
    
  end
  
  ##################
  #  self.gemsets  #
  ##################
  
  ###
  # Get hash of gemsets and their gem or gemset members.
  #
  # @return [Hash{Symbol=>Array<::Development::Gemset>}] Hash of gemsets and their gem or gemset members.
  #
  def self.gemsets
    
    return @gemsets
    
  end

  ####################
  #  self.directory  #
  ####################

  ###
  # Return path for directory name.
  #
  # @overload self.directory( name, path, gem_or_gemset, ... )
  #
  #   @param directory_name
  #   
  #          Name of named directory.
  #   
  #   @param path_parts
  #   
  #          The first can be a Symbol naming a directory; any can be String describing directory path.
  #
  # @return [::Development::Directory] Directory.
  #
  def self.directory( name, *path_parts )
    
    name = name.to_sym

    if directory_instance = @directories[ name ]
      unless path_parts.empty?
        directory_instance.set_path( *path_parts )
      end
    else
      if path_parts.empty?
        raise ::ArgumentError, 'Path required to create directory :' << name.to_s + '.'
      end
      @directories[ name ] = directory_instance = Directory.new( name, *path_parts )
    end

    return directory_instance
    
  end
  
  ########################
  #  self.get_directory  #
  ########################
  
  ###
  # Return directory with name.
  #
  # @param name
  #
  #        Name of directory to return.
  #
  # @return [::Development::Directory] Directory.
  #
  def self.get_directory( name )
    
    return @directories[ name.to_sym ]
    
  end

  ######################
  #  self.directories  #
  ######################
  
  ###
  # Get Hash of named directory names to paths.
  #
  # @return [Hash{Symbol=>::Development::Directory}]
  #
  def self.directories

    return @directories

  end

  ############################
  #  self.general_load_path  #
  ############################

  ###
  # Define general load path.
  #   
  # @param path
  # 
  #        String describing directory path.
  #
  # @return [::Development] Self.
  #
  def self.general_load_path( path )
    
    @general_load_paths.push( ::File.expand_path( path ) )
    
    return self
    
  end

  ###################################
  #  self.remove_general_load_path  #
  ###################################

  ###
  # Remove general load path.
  #   
  # @param path
  # 
  #        String describing directory path.
  #
  # @return [::Development] Self.
  #
  def self.remove_general_load_path( path )
    
    @general_load_paths.delete( ::File.expand_path( path ) )
    
    return self
    
  end
  
  #############################
  #  self.general_load_paths  #
  #############################
  
  ###
  # Get Array of paths that will be used for general loading purposes if a specific gem path is not given.
  #
  # @return [Array<String>] Paths to be used for general loading purposes.
  #
  def self.general_load_paths

    return @general_load_paths

  end  
  
  ###########################
  #  self.enabled_for_all?  #
  ###########################
  
  ###
  # Query whether Development is set to search in general paths for any gem, even if not explicitly enabled.
  #
  # @return [true,false] Whether general gem search is enabled.
  #
  def self.enabled_for_all?
    
    return @enable_for_all
    
  end

  ##################
  #  self.enable!  #
  ##################

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
  def self.enable!( *gem_or_gemset_names )
    
    if gem_or_gemset_names.empty?

      @enable_for_all = true
      @gems.each do |this_gem_name, this_gem|
        this_gem.enable!
      end
      @gemsets.each do |this_gemset_name, this_gemset|
        this_gemset.enable!
      end

    else

      gem_or_gemset_names.each do |this_gemset_or_gem_name|
        if this_gemset_or_gem_name.is_a?( ::Hash )
          this_gemset_or_gem_name.each do |this_gem, this_path|
            gem_instance = gem( this_gem )
            gem_instance.set_directory( this_path )
            gem_instance.enable!
          end
        else
          this_gem_or_gemset_reference_name = this_gemset_or_gem_name.to_s.gsub( '/', '-' ).to_sym
          if gem_instance = @gems[ this_gem_or_gemset_reference_name ]
            gem_instance.enable!
          end
          if gemset_instance = @gemsets[ this_gem_or_gemset_reference_name ]
            gemset_instance.enable!
          end
        end
      end

    end
    
    return self
    
  end

  ###################
  #  self.disable!  #
  ###################

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
  def self.disable!( *gem_or_gemset_names )

    if gem_or_gemset_names.empty?

      @enable_for_all = false
      @gems.each do |this_gem_name, this_gem|
        this_gem.disable!
      end
      @gemsets.each do |this_gemset_name, this_gemset|
        this_gemset.disable!
      end

    else

      gem_or_gemset_names.each do |this_gemset_or_gem_name|
        this_gem_or_gemset_reference_name = this_gemset_or_gem_name.to_s.gsub( '/', '-' ).to_sym
        if gem_instance = @gems[ this_gem_or_gemset_reference_name ]
          gem_instance.disable!
        end
        if gemset_instance = @gemsets[ this_gem_or_gemset_reference_name ]
          gemset_instance.disable!
        end
      end

    end

    return self

  end
  
  #############
  #  loaded?  #
  #############

  ###
  # Query whether gem was loaded via Development rather than standard require.
  #
  # @param gem_name
  #
  #        Name of gem.
  #
  # @return [true,false] Whether gem was loaded via Development.
  #
  def loaded?( gem_name )
    
    gem_require_name = gem_name.to_s.gsub( '/', '-' )
    
    return @loaded_gems.has_key?( gem_require_name.to_sym )
    
  end
  
  ######################################################################################################################
      private ##########################################################################################################
  ######################################################################################################################
    
  initialize

  ##################
  #  self.require  #
  ##################
  
  ###
  # Filters requires to match configuration specifications for loading development paths instead of production gems.
  #
  # @param gem_name_or_path
  #
  #        Gem name or path to file passed to {::Object#require}.
  #
  # @return [true,false] Whether Development handled gem_name_or_path (true) or processing should continue (false).
  #
  def self.require( gem_name_or_path )
    
    did_load = nil

    # if our path ends with an extension we are not requiring a gem and thus not responsible for managing it
    if ::File.extname( gem_name_or_path ).empty?

      gem_directory_name = gem_name_or_path.to_s.gsub( '/', '-' )
      gem_require_name = gem_name_or_path.to_s.gsub( '-', '/' )
      
      gem_reference_name = gem_directory_name.to_sym
      
      if @loaded_gems.has_key?( gem_reference_name )
        
        did_load = false

      else

        # look for gem name in enabled gems/gemsets
        if gem_instance = @gems[ gem_reference_name ]

          if gem_instance.enabled?
            load_gem_instance( gem_instance, gem_directory_name, gem_require_name )
            did_load = true
          elsif @enable_for_all && ! gem_instance.disabled?
            did_load = attempt_load_from_general_load_paths( gem_directory_name, gem_require_name )
          end
        
        # otherwise see if we perform general loading
        end
        
        if ! did_load and @enable_for_all
          attempt_load_from_general_load_paths( gem_directory_name, gem_require_name )
        end
        
      end
      
    end
    
    return did_load
    
  end
  
  ############################
  #  self.load_gem_instance  #
  ############################
  
  ###
  # Load gem using configuration information provides by gem instance.
  #
  # @param gem_instance
  #
  #        Gem instance.
  #
  # @param gem_directory_name
  #
  #        Gem directory in hyphenated gem-subgem format.
  #
  # @param gem_require_name
  #
  #        Gem name in slashed gem/subgem format.
  #
  # @return [::Development] Self.
  #
  def self.load_gem_instance( gem_instance, gem_directory_name, gem_require_name )
    
    gem_location = gem_instance.directory.path

    if path_is_gem_directory?( gem_location, gem_require_name )
      # already set
    elsif path_contains_gem_directory?( gem_location, gem_directory_name, gem_require_name )
      gem_location = ::File.join( gem_location, gem_directory_name )
    end

    load_gem_in_path( gem_location, gem_directory_name )
    @loaded_gems[ gem_require_name.to_sym ] = true
    
    return self
    
  end
  
  ###############################################
  #  self.attempt_load_from_general_load_paths  #
  ###############################################
  
  ###
  # Attempt to load gem from general load paths if any are provided.
  #
  # @param gem_directory_name
  #
  #        Gem directory in hyphenated gem-subgem format.
  #
  # @param gem_require_name
  #
  #        Gem name in slashed gem/subgem format.
  #
  # @return [::Development] Self.
  #
  def self.attempt_load_from_general_load_paths( gem_directory_name, gem_require_name )
    
    gem_require_name = gem_directory_name.to_sym
    
    did_load = false
    
    # look in each path for gem - use first to match
    @general_load_paths.each do |this_load_path|

      if path_is_gem_directory?( this_load_path, gem_require_name )

        load_gem_in_path( this_load_path, gem_directory_name )
        @loaded_gems[ gem_require_name ] = true
        did_load = true
        break

      elsif path_contains_gem_directory?( this_load_path, gem_directory_name, gem_require_name )

        gem_location = ::File.join( this_load_path, gem_directory_name )

        load_gem_in_path( gem_location, gem_directory_name )
        @loaded_gems[ gem_require_name ] = true
        did_load = true
        break

      end

    end
    
    return did_load
    
  end

  #################################
  #  self.path_is_gem_directory?  #
  #################################
  
  ###
  # Query whether gem name is present in load path, meaning load path specifies the gem directory.
  #
  # @param load_path 
  #
  #        Path where gem directory might be located.
  #
  # @param gem_require_name 
  #
  #        Name of gem. Assumes gem-subname is used rather than gem/subname.
  #
  # @return [true,false] Whether gem name is present.
  #
  def self.path_is_gem_directory?( load_path, gem_require_name )
    
    exists_at_load_path = false
    
    gem_require_file = ::File.join( load_path, 'lib', gem_require_name ) + '.rb'

    if ::File.exist?( ::File.expand_path( gem_require_file ) )
      exists_at_load_path = true
    end
    
    return exists_at_load_path
    
  end

  #######################################
  #  self.path_contains_gem_directory?  #
  #######################################
  
  ###
  # Query whether gem name is present at load path, meaning load path specifies the directory holding gem directory.
  #
  # @param load_path 
  #
  #        Path where gem directory might be located.
  #
  # @param gem_directory_name 
  #
  #        Name of gem. Assumes gem-subname is used rather than gem/subname.
  #
  # @param gem_require_name 
  #
  #        Name of gem. Assumes gem/subname is used rather than gem-subname.
  #
  # @return [true,false] Whether gem name is present.
  #
  def self.path_contains_gem_directory?( load_path, gem_directory_name, gem_require_name )
    
    exists_at_load_path = false
    
    gem_path = ::File.join( load_path, gem_directory_name )
    
    gem_require_file = ::File.join( gem_path, 'lib', gem_require_name ) + '.rb'

    if ::Dir.exist?( ::File.expand_path( gem_path ) ) and 
       ::File.exist?( ::File.expand_path( gem_require_file ) )
      
      exists_at_load_path = true
    
    end
    
    return exists_at_load_path
    
  end

  ###########################
  #  self.load_gem_in_path  #
  ###########################
  
  ###
  # Load gem from gem directory path. Assumes gem is present in path.
  #
  # @param load_path 
  #
  #        Path where gem directory might be located.
  #
  # @param gem_directory_name 
  #
  #        Name of gem. Assumes gem-subname is used rather than gem/subname.
  #
  # @return [true,false] Whether gem name is present.
  #
  def self.load_gem_in_path( load_path, gem_directory_name )
        
    gem_require_file = ::File.join( load_path, 'lib', gem_directory_name ) + '.rb'
    require_relative( ::File.expand_path( gem_require_file ) )
    
  end

  ##################################
  #  self.load_configuration_file  #
  ##################################
  
  ###
  # Load Development configuration file.
  #
  # @param path 
  #
  #        Location of configuration file.
  #
  # @return [::Development] Self.
  #
  def self.load_configuration_file( path )
    
    absolute_path = ::File.expand_path( path )
    
    if ::File.exists?( absolute_path )
      ::Development::ConfigurationInterface.module_eval do
        alias_method :gem, :gem_method
      end
      load( absolute_path )
      ::Development::ConfigurationInterface.module_eval do
        remove_method :gem
      end
    end
    
    return self
    
  end
  
end

# post-load setup
require_relative './setup.rb'
