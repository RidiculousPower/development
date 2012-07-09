
require 'array-unique'

###
# Singleton that manages configurations and requires.
#
module ::Development
  
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
    
    return @loaded_gems.include?( gem_name )
    
  end
  
  ####################
  #  self.directory  #
  ####################
  
  ###
  # Return path for directory name.
  #
  # @param directory_name
  #
  #        Name of named directory.
  #
  # @return [String] Directory path associated with directory name.
  #
  def self.directory( directory_name )

    return @named_directories[ directory_name.to_sym ]
    
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

  ############################
  #  self.named_directories  #
  ############################
  
  ###
  # Get Hash of named directory names to paths.
  #
  # @return [Hash{Symbol=>String}]
  #
  def self.named_directories

    return @named_directories

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

  #######################
  #  self.enabled_gems  #
  #######################
  
  ###
  # Get gems that have been explicitly enabled.
  #
  # @return [Array<Symbol>] Array of gem or gemset names.
  #
  def self.enabled_gems
    
    return @enabled_gems
    
  end

  ########################
  #  self.disabled_gems  #
  ########################
  
  ###
  # Get gems that have been explicitly disabled.
  #
  # @return [Array<Symbol>] Array of gem or gemset names.
  #
  def self.disabled_gems

    return @disabled_gems

  end

  ##################
  #  self.gemsets  #
  ##################
  
  ###
  # Get hash of gemsets and their gem or gemset members.
  #
  # @return [Hash{Symbol=>Array<Symbol>}] Hash of gemsets and their gem or gemset members.
  #
  def self.gemsets
    
    return @gemsets
    
  end

  ####################
  #  self.locations  #
  ####################
  
  ###
  # Hash of locations and the gems or gemsets located at each.
  #
  # @return [Hash{Symbol=>Array{String}] 
  #
  def self.locations
    
    return @locations
    
  end

  ###################
  #  self.location  #
  ###################
  
  ###
  # Get gems or gemsets associated with location.
  #
  # @param location_name
  #
  #        Name of location.
  #
  # @return [Array<Symbol>]
  #
  def self.location( location_name )
    
    return @locations[ location_name.to_sym ]
    
  end
  
  ######################################################################################################################
      private ##########################################################################################################
  ######################################################################################################################
  
  ###
  # @private
  #
  # Container to namespace exceptions.
  #
  module Exception
  end

  ###
  # Name of configuration file: .development.
  #
  ConfigurationFileName = '.development'
  
  @enabled_gems = ::Array::Unique.new
  @disabled_gems = ::Array::Unique.new
  
  @gemsets = { }
  @gem_locations = { }
  
  @general_load_paths = ::Array::Unique.new

  @loaded_gems = ::Array::Unique.new

  @named_directories = { }
  @locations = { }

  @enable_for_all = false

  ################
  #  self.clear  #
  ################
  
  ###
  # Reset internal tracking variables.
  #
  # @return [Development] Self.
  #
  def self.clear
    
    @enabled_gems.clear
    @disabled_gems.clear
    @gemsets.clear
    @general_load_paths.clear
    @loaded_gems.clear
    @named_directories.clear
    
    return self
    
  end
  
  ##################################
  #  self.load_configuration_file  #
  ##################################
  
  ###
  # Load configuration file.
  #   Looks first in project directory, second in home directory. 
  #   If configuration file is not found in project directory, Development will not load.
  #
  def self.load_configuration_file( path )
        
    # we build up a configuration line and process when we reach its end (the next line)
    expression_string = ''

    configuration_file_path = ::File.expand_path( path )
    
    @line_number = 0

    ::File.open( configuration_file_path ).each_with_index do |this_line, this_line_number|
    
      # when parse_configuration_file_line returns false we have a complete expression
      while parse_configuration_file_line( expression_string, this_line )

        # process expression_string
        parse_configuration_expression( expression_string )

        # reset expression_string
        expression_string.clear
        
        # update line number where expression begins
        @line_number = this_line_number
        unless this_line.empty?
          @line_number += 1
        end
        
        # loop will cause start with this_line, which told parse_configuration_file_line 
        # that we were done, and which is therefore not yet processed
        
      end

    end

    parse_configuration_expression( expression_string )
    
  end
  
  ########################################
  #  self.parse_configuration_file_line  #
  ########################################

  ###
  # Parses configuration_file_line to construct expression_string from multiple configuration_file_lines.
  #
  # @param expression_string 
  #
  #        Configuration expression that spans one or more lines in configuration file.
  #
  # @param configuration_file_line 
  #
  #        Literal line from configuration file (may only be part of an expression).
  #
  # @return [true,false] Whether expression is still complete. 
  #                      True means configuration_file_line was not processed.
  #
  def self.parse_configuration_file_line( expression_string, configuration_file_line, continuation = false )

    expression_complete = false

    # if we begin with a comment we can throw away the line
    if configuration_file_line[ 0 ] == '#'
      
      # nothing to do - we just ignore the line
      
    # if we begin with whitespace we have a continuation
    elsif configuration_file_line[ 0 ] =~ /\s/
      
      configuration_file_line.strip!
      
      expression_complete = parse_configuration_file_line( expression_string, configuration_file_line, true )
    
    elsif continuation
      
      unless expression_string.empty?
        unless configuration_file_line.empty?
          expression_string << ' '
        end
      end
      expression_string << configuration_file_line.strip

    elsif expression_string.empty?
      
      expression_string.replace( configuration_file_line.strip )
    
    # otherwise we reached the next line of the configuration file
    else

      expression_complete = true

    end
    
    return expression_complete
    
  end
  
  #########################################
  #  self.parse_configuration_expression  #
  #########################################
  
  ###
  # Parse single configuration expression built up from one or more actual configuration file lines.
  #
  # @param expression_string
  #
  #        String describing configuration directive.
  #
  # @return [Object] self.
  #
  def self.parse_configuration_expression( expression_string )
    
    case expression_string[ 0 ]
      
      # + - named directory expression
      when '+'

        # either a directory definition or a general directory directive
        # directory definitions are multiplart, whereas general directory definitions are one part
        parse_named_directory_expression( expression_string )
                
      # - - remove general path
      when '-'

        parse_remove_general_load_path_expression( expression_string )

      # = - gemset expression
      when '='

        parse_gemset_expression( expression_string )

      # @ - location expression
      when '@'

        parse_general_directory_or_location_expression( expression_string )

      # ! - enable/disable expression
      when '!'

        parse_enable_disable_expression( expression_string )
      
      # general path expression
      else

        parse_general_load_path_expression( expression_string )
      
    end
    
    return self
    
  end
  
  #########################################################
  #  self.parse_general_directory_or_location_expression  #
  #########################################################
  
  ###
  # Parse expression string that has been determined as either a general path or location expression.
  #
  # @param expression_string
  #
  #        String describing general path or location expression.
  #
  # @return [Object] Self.
  #
  def self.parse_general_directory_or_location_expression( expression_string )
    
    # if we have multiple parts
    if whitespace_index = expression_string =~ /\s/
      
      parse_location_expression( expression_string )
    
    # if we have one part
    else
      
      parse_general_load_path_expression( expression_string )
      
    end
    
    return self
    
  end
  
  ###########################################
  #  self.parse_named_directory_expression  #
  ###########################################
  
  ###
  # Parse expression string that has been determined as a named directory expression.
  #
  # @param expression_string
  #
  #        String describing named directory expression.
  #
  # @return [Object] Self.
  #
  def self.parse_named_directory_expression( expression_string )
    
    # +directory_name path

    unless whitespace_index = expression_string =~ /\s/
      raise Exception::MalformedExpression::
            MalformedNamedDirectoryExpression.new( expression_string, @line_number )
    end

    directory_name = expression_string.slice( 1, whitespace_index - 1 )
    slice_length = expression_string.length - whitespace_index
    path = expression_string.slice( whitespace_index + 1, slice_length ).strip

    case path[0]
      when '@'
        path_parts = path.split( '/' )
        named_path_name = path_parts.shift
        named_path_name.slice!( 0, 1 )
        path = ::File.join( directory( named_path_name ), path_parts )
    end
    
    @named_directories[ directory_name.to_sym ] = ::File.expand_path( path )
    
    return self
    
  end

  ##################################
  #  self.parse_gemset_expression  #
  ##################################

  ###
  # Parse expression string that has been determined as a gemset expression.
  #
  # @param expression_string
  #
  #        String describing gemset expression.
  #
  # @return [Object] Self.
  #
  def self.parse_gemset_expression( expression_string )

    # =gemset gem_or_set_name[,] ...
    # =gemset +gem_or_set_name[,] ...
    # =gemset -gem_or_set_name[,] ...

    gemset_name = parse_base_action_from_expression_string( expression_string )

    gemset = create_gemset( gemset_name )
    
    parse_gem_names_from_expression_string( gemset, expression_string )
    
    return self
    
  end

  ###################################################
  #  self.parse_base_action_from_expression_string  #
  ###################################################
  
  ###
  # Parse signal character (+, -, =, @, !) and base action string from expression.
  #
  # @param expression_string
  #
  #        Expression string.
  #
  # @return [String] Base action string.
  #
  def self.parse_base_action_from_expression_string( expression_string )
    
    base_action = nil
    
    # get rid of =
    expression_string.slice!( 0, 1 )
    
    if whitespace_index = expression_string =~ /\s/
      base_action = expression_string.slice!( 0, whitespace_index )
    else
      base_action = expression_string.dup
      expression_string.clear
    end
    
    expression_string.strip!

    return base_action
    
  end
  
  #################################################
  #  self.parse_gem_names_from_expression_string  #
  #################################################

  ###
  # Parse gem name list separated by optional comma and white space from expression.
  #
  # @param array
  #
  #        Array to add parsed data to.
  #
  # @param expression_string
  #
  #        Expression string.
  #
  # @param require_exist [true,false]
  #
  #        Raise exception if gems do not exist.
  #
  # @return [Development] Self.
  #
  def self.parse_gem_names_from_expression_string( array, expression_string, require_exist = false )

    while next_whitespace_index = expression_string =~ /\s/
      parse_gem_name_from_expression_string( array, expression_string, next_whitespace_index )
    end

    # also slice till the end
    parse_gem_name_from_expression_string( array, expression_string, expression_string.length, require_exist )
    
    return self
    
  end

  ################################################
  #  self.parse_gem_name_from_expression_string  #
  ################################################
  
  ###
  # Helper method to slice gem name from expression string and add or subtract from gemset.
  #
  # @param array
  #
  #        Array to add parsed data to.
  #
  # @param gemset
  #
  #        Gemset instance.
  #
  # @param expression_string
  #
  #        Expression string.
  # 
  # @param slice_to_index
  #
  #        Index to slice expression string to.
  #
  # @param require_exist [true,false]
  #
  #        Raise exception if gems do not exist.
  #
  # @return [Symbol] Parsed gem name.
  #
  def self.parse_gem_name_from_expression_string( array, expression_string, slice_to_index, require_exist = false )
    
    gem_name = expression_string.slice!( 0, slice_to_index )

    unless gem_name.empty?
            
      case gem_name[ -1 ]
        when ','
          gem_name.slice!( -1, 1 )
      end
    
      should_add = true
      
      case gem_name[ 0 ]
        when '+'
          gem_name.slice!( 0, 1 )
        when '-'
          gem_name.slice!( 0, 1 )
          array.delete( gem_name.to_sym )
          should_add = false
        else
      end

      # ensure we have 'gem-subname' rather than 'gem/subname'
      # we really just need one or the other consistently
      gem_name.gsub!( '/', '-' )

      gem_name = gem_name.to_sym

      if require_exist
        unless @enabled_gems.has_key?( gem_name ) or 
               @disabled_gems.has_key?( gem_name ) or 
               @gemsets.has_key?( gem_name)
          raise Exception::ExpressionError::UnknownGemOrGemsetName.new( gem_name, @line_number )
        end
      end

      if should_add
        array.push( gem_name )
      end
      
      expression_string.strip!

    end
    
    return gem_name
    
  end

  ########################
  #  self.create_gemset  #
  ########################
  
  ###
  # Create gemset with name.
  #
  # @param gemset_name
  #
  #        Name of gemset.
  #
  # @return [Array] Gemset.
  #
  def self.create_gemset( gemset_name )

    gemset_name = gemset_name.to_sym
    
    unless gemset = @gemsets[ gemset_name ]
      @gemsets[ gemset_name ] = gemset = ::Array::Unique.new
    end
    
    return gemset
    
  end

  #################
  #  self.gemset  #
  #################
  
  ###
  # Get gemset with name.
  #
  # @param gemset_name
  #
  #        Name of gemset.
  #
  # @return [Array] Gemset.
  #
  def self.gemset( gemset_name )
    
    return @gemsets[ gemset_name.to_sym ]
    
  end

  ####################################
  #  self.parse_location_expression  #
  ####################################
    
  ###
  # Parse expression string that has been determined as a location expression.
  #
  # @param expression_string
  #
  #        String describing location expression.
  #
  # @return [Object] Self.
  #
  def self.parse_location_expression( expression_string )
    
    # @directory_name gem_or_set_name[,] ...
    
    directory_name = parse_base_action_from_expression_string( expression_string )
    
    directory_name = directory_name.to_sym
    
    unless @named_directories.has_key?( directory_name )
      raise Exception::MalformedExpression::UnknownDirectoryName.new( directory_name, @line_number )
    end
    
    unless directory_members = @locations[ directory_name ]
      @locations[ directory_name ] = directory_members = ::Array::Unique.new
    end
    
    parse_gem_names_from_expression_string( directory_members, expression_string )
    
    directory_members.each do |this_gem_or_gemset|
      if gemset = @gemsets[ this_gem_or_gemset ]
        gemset.each do |this_gem|
          @gem_locations[ this_gem ] = directory_name
        end
      else
        @gem_locations[ this_gem_or_gemset ] = directory_name
      end
    end
    
    return self
    
  end

  ##########################################
  #  self.parse_enable_disable_expression  #
  ##########################################

  ###
  # Parse expression string that has been determined as a enable/disable expression.
  #
  # @param expression_string
  #
  #        String describing enable/disable expression.
  #
  # @return [Object] Self.
  #
  def self.parse_enable_disable_expression( expression_string )
    
    # !enable
    # !disable
    # !enable gem_or_set_name[,] ...
    # !disable gem_or_set_name[,] ...
    
    # enable or disable
    enable_or_disable = parse_base_action_from_expression_string( expression_string )
    
    gems = nil
    unless expression_string.empty?
      gems = ::Array::Unique.new
      parse_gem_names_from_expression_string( gems, expression_string )
    end
    
    case enable_or_disable = enable_or_disable.to_sym
      
      when :enable
        
        if gems
          gems.each do |this_gem, true_value|
            @enabled_gems.push( this_gem )
            @disabled_gems.delete( this_gem )
          end
        else
          @disabled_gems.delete_if do |this_gem, true_value|
            @enabled_gems.push( this_gem )
            true
          end
          @enable_for_all = true
        end
        
      when :disable

        if gems
          gems.each do |this_gem, true_value|
            @disabled_gems.push( this_gem )
            @enabled_gems.delete( this_gem )
          end
        else
          @enabled_gems.delete_if do |this_gem, true_value|
            @disabled_gems.push( this_gem )
            true
          end 
          @enable_for_all = false
        end
        
    end
    
    # do we have gems?
    
    return self
    
  end

  #############################################
  #  self.parse_general_load_path_expression  #
  #############################################

  ###
  # Parse expression string that has been determined as a general directory expression.
  #
  # @param expression_string
  #
  #        String describing general directory expression.
  #
  # @return [Object] Self.
  #
  def self.parse_general_load_path_expression( expression_string )
    
    # path/to/directory, ~/path/to/directory, /path/to/directory
    # +directory_name/path/from/directory
    
    case expression_string[ 0 ]
      
      when '@'

        path_parts = expression_string.split( '/' )
        named_directory = path_parts.shift
        named_directory.slice!( 0, 1 )
        named_directory = named_directory.to_sym
        expression_string = ::File.expand_path( ::File.join( directory( named_directory ), path_parts ) )
      
    end
    
    @general_load_paths.push( ::File.expand_path( expression_string ) )
    
    return self
    
  end

  ####################################################
  #  self.parse_remove_general_load_path_expression  #
  ####################################################
  
  ###
  # Parse expression string that has been determined as a remove-general-directory expression.
  #
  # @param expression_string
  #
  #        String describing remove general directory expression.
  #
  # @return [Object] Self.
  #
  def self.parse_remove_general_load_path_expression( expression_string )
    
    # -path/to/directory, -~/path/to/directory, -/path/to/directory
    
    expression_string.slice!( 0, 1 )
    path_string = expression_string.dup
    expression_string.clear

    @general_load_paths.delete( ::File.expand_path( path_string ) )
    
    return self
    
  end

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
    
    did_load = false

    # if our path ends with an extension we are not requiring a gem and thus not responsible for managing it
    if ::File.extname( gem_name_or_path ).empty?

      gem_name = gem_name_or_path.to_s
      
      # ensure we have 'gem-subname' rather than 'gem/subname'
      # we really just need one or the other consistently
      gem_directory_name = gem_name.gsub( '/', '-' )
      
      # look for gem name in enabled gems/gemsets
      if @enabled_gems.include?( gem_name.to_sym ) or 
         @enable_for_all && ! @disabled_gems.include?( gem_name.to_sym )

        if directory_name = @gem_locations[ gem_name.to_sym ]   and
           load_path = directory( directory_name )              and
           gem_name_at_load_path?( load_path, gem_directory_name, true )
          
          load_gem_from_path( load_path, gem_directory_name )
          did_load = true
          
        else
          # look in each path for gem - use first to match
          @general_load_paths.each do |this_load_path|

            # look for gem name at load path
            if gem_name_at_load_path?( this_load_path, gem_name )
              load_gem_from_path( this_load_path, gem_name )
              did_load = true
            end

          end
        
        end
    
      end

    end
    
    return did_load
    
  end

  #################################
  #  self.gem_name_at_load_path?  #
  #################################
  
  ###
  # Query whether gem name is present at load path.
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
  def self.gem_name_at_load_path?( load_path, gem_directory_name, require_gem_at_path = false )
    
    exists_at_load_path = false
    
    gem_name = gem_directory_name.gsub( '-', '/' )
    gem_path = ::File.join( load_path, gem_directory_name )
    
    gem_require_file = ::File.join( gem_path, 'lib', gem_name ) + '.rb'
    
    if ::Dir.exist?( ::File.expand_path( gem_path ) ) and 
       ::File.exist?( ::File.expand_path( gem_require_file ) )
      
      exists_at_load_path = true
    
    end
    
    return exists_at_load_path
    
  end
  
  #############################
  #  self.load_gem_from_path  #
  #############################
  
  ###
  # Load gem from gem path. Assumes gem is present at path.
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
  def self.load_gem_from_path( load_path, gem_directory_name )
        
    gem_name = gem_directory_name.gsub( '-', '/' )
    gem_path = ::File.join( load_path, gem_directory_name )
    
    gem_require_file = ::File.join( gem_path, 'lib', gem_name ) + '.rb'
    
    require_relative( ::File.expand_path( gem_require_file ) )
    
  end
  
end

require_relative 'development/require.rb'

require_relative 'development/exception/expression_error.rb'
require_relative 'development/exception/expression_error/unknown_directory_name.rb'
require_relative 'development/exception/expression_error/unknown_gem_or_gemset_name.rb'

require_relative 'development/exception/malformed_expression.rb'
require_relative 'development/exception/malformed_expression/malformed_named_directory_expression.rb'
require_relative 'development/exception/malformed_expression/malformed_gemset_expression.rb'
require_relative 'development/exception/malformed_expression/malformed_location_expression.rb'
require_relative 'development/exception/malformed_expression/malformed_enable_disable_expression.rb'
require_relative 'development/exception/malformed_expression/malformed_general_directory_expression.rb'
require_relative 'development/exception/malformed_expression/malformed_remove_general_directory_expression.rb'

###
# Object is enabled with Development require functionality.
#
class ::Object
  include ::Development::Require
end

#::Development.load_configuration_file( ::File.join( '~', ConfigurationFileName ) )
