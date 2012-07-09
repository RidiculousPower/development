
require_relative '../lib/development.rb'

describe ::Development do
  
  before :each do
    ::Development.clear
  end
  
  ###########################################
  #  self.parse_named_directory_expression  #
  ###########################################

  it 'can parse a named directory expression' do
    ::Proc.new { ::Development.parse_named_directory_expression( '+directory_name' ) }.should raise_error( ::Development::Exception::MalformedExpression::MalformedNamedDirectoryExpression )
    ::Development.parse_named_directory_expression( '+directory_name some/path/from/here' )
    ::Development.directory( :directory_name ).should == ::File.expand_path( 'some/path/from/here' )
  end
  
  ##################################
  #  self.parse_gemset_expression  #
  ##################################

  it 'can parse a gemset expression' do
    ::Development.parse_gemset_expression( '=gemset' )
    ::Development.gemset( :gemset ).should == [ ]
    ::Development.parse_gemset_expression( '=another_gemset some_gem, +some_other_gem, another_gem, -another_gem' )
    ::Development.gemset( :another_gemset ).should == [ :some_gem, :some_other_gem ]
    ::Development.parse_gemset_expression( '=some_other_gemset some_gem +some_other_gem another_gem -another_gem' )
    ::Development.gemset( :some_other_gemset ).should == [ :some_gem, :some_other_gem ]
  end
  
  ####################################
  #  self.parse_location_expression  #
  ####################################

  it 'can parse a location expression' do
    ::Development.parse_named_directory_expression( '+directory_name some/path/from/here' )
    ::Development.directory( :directory_name ).should == ::File.expand_path( 'some/path/from/here' )
    ::Development.parse_named_directory_expression( '+directory_name some/path/from/here' )
    ::Development.parse_location_expression( '@directory_name gem_name, some_other_gem' )
    ::Proc.new { ::Development.parse_location_expression( '@unknown_directory_name gem_name, some_other_gem' ) }.should raise_error( ::Development::Exception::MalformedExpression::UnknownDirectoryName )
    
  end
  
  ##########################################
  #  self.parse_enable_disable_expression  #
  ##########################################

  it 'can parse an enable/disable expression' do

    ::Development.parse_gemset_expression( '=some_gemset some_gem, some_other_gem, some_gemset' )

    ::Development.parse_enable_disable_expression( '!enable some_gem, some_other_gem, some_gemset' )
    ::Development.enabled_for_all?.should == false
    ::Development.enabled_gems.should == [ :some_gem, :some_other_gem, :some_gemset ]
    ::Development.disabled_gems.should == [ ]
    
    ::Development.parse_enable_disable_expression( '!disable some_gem, some_other_gem' )
    ::Development.enabled_for_all?.should == false
    ::Development.enabled_gems.should == [ :some_gemset ]
    ::Development.disabled_gems.should == [ :some_gem, :some_other_gem ]

    ::Development.parse_enable_disable_expression( '!enable some_gem, some_other_gem' )
    ::Development.enabled_for_all?.should == false
    ::Development.enabled_gems.should == [ :some_gemset, :some_gem, :some_other_gem ]
    ::Development.disabled_gems.should == [ ]

    ::Development.parse_enable_disable_expression( '!disable' )
    ::Development.enabled_for_all?.should == false
    ::Development.enabled_gems.should == [ ]
    ::Development.disabled_gems.should == [ :some_gemset, :some_gem, :some_other_gem ]
    
    ::Development.parse_enable_disable_expression( '!enable' )
    ::Development.enabled_for_all?.should == true
    ::Development.enabled_gems.should == [ :some_gemset, :some_gem, :some_other_gem ]
    ::Development.disabled_gems.should == [ ]

    ::Development.parse_enable_disable_expression( '!disable' )
    ::Development.enabled_for_all?.should == false
    ::Development.enabled_gems.should == [ ]
    ::Development.disabled_gems.should == [ :some_gemset, :some_gem, :some_other_gem ]
  
    ::Development.parse_enable_disable_expression( '!enable some_gemset' )
    ::Development.enabled_for_all?.should == false
    ::Development.enabled_gems.should == [ :some_gem, :some_other_gem, :some_gemset ]
    ::Development.disabled_gems.should == [ ]

    ::Development.parse_enable_disable_expression( '!disable' )
    ::Development.enabled_for_all?.should == false
    ::Development.enabled_gems.should == [ ]
    ::Development.disabled_gems.should == [ :some_gem, :some_other_gem, :some_gemset ]
    
  end
  
  ####################################################
  #  self.parse_general_load_path_expression         #
  #  self.parse_remove_general_load_path_expression  #
  ####################################################

  it 'can parse a general load path expression or a remove-general load path expression' do
    
    ::Development.parse_general_load_path_expression( '/path/to/somewhere' )
    ::Development.general_load_paths.include?( '/path/to/somewhere' ).should == true
    ::Development.parse_remove_general_load_path_expression( '-/path/to/somewhere' )
    ::Development.general_load_paths.include?( '/path/to/somewhere' ).should == false

    ::Development.parse_general_load_path_expression( '~/path/to/somewhere' )
    ::Development.general_load_paths.include?( ::File.expand_path( '~/path/to/somewhere' ) ).should == true
    ::Development.parse_remove_general_load_path_expression( '-~/path/to/somewhere' )
    ::Development.general_load_paths.include?( ::File.expand_path( '~/path/to/somewhere' ) ).should == false

    ::Development.parse_general_load_path_expression( ::File.expand_path( '../../path/to/somewhere' ) )
    ::Development.general_load_paths.include?( ::File.expand_path( '../../path/to/somewhere' ) ).should == true
    ::Development.parse_remove_general_load_path_expression( '-../../path/to/somewhere' )
    ::Development.general_load_paths.include?( ::File.expand_path( '../../path/to/somewhere' ) ).should == false

    ::Development.parse_general_load_path_expression( ::File.expand_path( 'path/to/somewhere' ) )
    ::Development.general_load_paths.include?( ::File.expand_path( 'path/to/somewhere' ) ).should == true
    ::Development.parse_remove_general_load_path_expression( '-path/to/somewhere' )
    ::Development.general_load_paths.include?( ::File.expand_path( 'path/to/somewhere' ) ).should == false

  end

  #########################################################
  #  self.parse_general_directory_or_location_expression  #
  #########################################################

  it 'can parse a general path or named directory expression' do

    ::Development.parse_named_directory_expression( '+named_path ~/path/to/somewhere' )
    ::Development.directory( :named_path ).should == ::File.expand_path( '~/path/to/somewhere' )

    ::Development.parse_general_directory_or_location_expression( '@named_path some_gem, some_other_gem' )
    ::Development.location( :named_path ).should == [ :some_gem, :some_other_gem ]
    
    ::Development.parse_general_directory_or_location_expression( '@named_path/path/to/somewhere' )
    ::Development.general_load_paths.include?( ::File.expand_path( '~/path/to/somewhere/path/to/somewhere' ) ).should == true
    
  end
    
  ########################################
  #  self.parse_configuration_file_line  #
  ########################################

  it 'can parse a line from a file to create an expression from multiple lines' do
    
    expression_string = ''
    
    # empty expression, text at beginning of line
    ::Development.parse_configuration_file_line( expression_string, '+named_path path/to/somewhere' ).should == false
    expression_string.should == '+named_path path/to/somewhere'
    ::Development.parse_configuration_file_line( expression_string, '@named_path some_gem' ).should == true
    expression_string.should == '+named_path path/to/somewhere'

    expression_string = ''
    ::Development.parse_configuration_file_line( expression_string, '@named_path some_gem' ).should == false
    expression_string.should == '@named_path some_gem'
    ::Development.parse_configuration_file_line( expression_string, '            some_other_gem' ).should == false
    expression_string.should == '@named_path some_gem some_other_gem'
    ::Development.parse_configuration_file_line( expression_string, '            another_gem' ).should == false
    expression_string.should == '@named_path some_gem some_other_gem another_gem'
    ::Development.parse_configuration_file_line( expression_string, '            yet_another_gem' ).should == false
    expression_string.should == '@named_path some_gem some_other_gem another_gem yet_another_gem'
    ::Development.parse_configuration_file_line( expression_string, '@named_path a_gem' ).should == true
    expression_string.should == '@named_path some_gem some_other_gem another_gem yet_another_gem'
    
    # empty expression, comment
    expression_string = ''
    ::Development.parse_configuration_file_line( expression_string, '# blah blah blah blah' ).should == false
    expression_string.should == ''
    
    # part expression, indented text
    ::Development.parse_configuration_file_line( expression_string, '@named_path some_gem' ).should == false
    ::Development.parse_configuration_file_line( expression_string, '            some_other_gem' ).should == false

    # part expression, comment
    ::Development.parse_configuration_file_line( expression_string, '# blah blah blah blah' ).should == false
    ::Development.parse_configuration_file_line( expression_string, '            another_gem' ).should == false
    ::Development.parse_configuration_file_line( expression_string, '            # blah!' ).should == false
    ::Development.parse_configuration_file_line( expression_string, '            yet_another_gem' ).should == false
    ::Development.parse_configuration_file_line( expression_string, '@named_path some_unnamed_gem' ).should == true
        
  end
  
  #########################################
  #  self.parse_configuration_expression  #
  #########################################
  
  it 'can parse a configuration expression assembled from configuration file line(s)' do
    
    # + - named directory expression
    ::Development.parse_configuration_expression( '+directory_name some/path/from/here' )
    ::Development.directory( :directory_name ).should == ::File.expand_path( 'some/path/from/here' )
              
    # = - gemset expression
    ::Development.parse_configuration_expression( '=another_gemset some_gem, +some_other_gem, another_gem, -another_gem' )
    ::Development.gemset( :another_gemset ).should == [ :some_gem, :some_other_gem ]

    # @ - location expression
    ::Development.parse_configuration_expression( '+directory_name some/path/from/here' )
    ::Development.directory( :directory_name ).should == ::File.expand_path( 'some/path/from/here' )

    # ! - enable/disable expression
    ::Development.parse_configuration_expression( '!enable some_gem, some_other_gem, some_gemset' )
    ::Development.enabled_for_all?.should == false
    ::Development.enabled_gems.should == [ :some_gem, :some_other_gem, :some_gemset ]
    ::Development.disabled_gems.should == [ ]

    ::Development.parse_configuration_expression( '!disable' )
    ::Development.enabled_for_all?.should == false
    ::Development.enabled_gems.should == [ ]
    ::Development.disabled_gems.should == [ :some_gem, :some_other_gem, :some_gemset ]
    
    # general path expression
    # - - remove general path
    ::Development.parse_configuration_expression( '/path/to/somewhere' )
    ::Development.general_load_paths.include?( '/path/to/somewhere' ).should == true
    ::Development.parse_configuration_expression( '-/path/to/somewhere' )
    ::Development.general_load_paths.include?( '/path/to/somewhere' ).should == false
    
  end

  #################################
  #  self.gem_name_at_load_path?  #
  #################################

  it 'can find a gem name at a load path' do
    ::Development.gem_name_at_load_path?( 'spec', 'mock_gem' ).should == true
    ::Development.gem_name_at_load_path?( 'spec', 'mock_gem-subgem' ).should == true
  end

  #############################
  #  self.load_gem_from_path  #
  #############################

  it 'can load a gem from a development path' do

    defined?( ::Development::MockGem ).should == nil
    ::Development.load_gem_from_path( 'spec', 'mock_gem' )
    defined?( ::Development::MockGem ).should == 'constant'

    defined?( ::Development::MockGem::Subgem ).should == nil
    ::Development.load_gem_from_path( 'spec', 'mock_gem-subgem' )
    defined?( ::Development::MockGem::Subgem ).should == 'constant'
    
  end
  
  ##################################
  #  self.load_configuration_file  #
  ##################################
  
  it 'can load a configuration file' do
    
    ::Development.load_configuration_file( 'example.development' )

    ::Development.gemset( :ruby ).should == [ :"module-cluster" ]
    ::Development.gemset( :hooked_objects ).should == [ :"hash-hooked", :"array-hooked", :"array-sorted", :"array-unique", :"array-sorted-unique" ]
    ::Development.gemset( :compositing_objects ).should == [ :"hash-compositing", :"array-compositing", :"array-sorted-compositing", :"array-unique-compositing", :"array-sorted-unique-compositing" ]
    ::Development.gemset( :ridiculous_power ).should == [ :"persistence", :"magnets" ]

    ::Development.directory( :code ).should == ::File.expand_path( '~/Projects' )
    ::Development.directory( :ridiculous_power ).should == ::File.expand_path( '~/Projects/rp' )
    ::Development.directory( :ruby ).should == ::File.expand_path( '~/Projects/rp/ruby' )
    ::Development.directory( :hooked_objects ).should == ::File.expand_path( '~/Projects/rp/ruby/hooked_objects' )
    ::Development.directory( :compositing_objects ).should == ::File.expand_path( '~/Projects/rp/ruby/compositing_objects' )

    ::Development.location( :hooked_objects ).should == [ :hooked_objects ]
    ::Development.location( :compositing_objects ).should == [ :compositing_objects ]
    ::Development.location( :ridiculous_power ).should == [ :ridiculous_power ]
    
    ::Development.enabled_gems.should == [ ]
    ::Development.enabled_for_all?.should == true
    
  end

  ####################
  #  Object.require  #
  ####################
  
  it 'hooks require for registered gems' do
    
    ::Development.parse_configuration_expression( '+directory_name ./spec' )
    ::Development.parse_configuration_expression( '@directory_name require_mock' )
    ::Development.parse_configuration_expression( '!enable require_mock' )
    
    defined?( ::Development::RequireMock ).should == nil
    require 'require_mock'
    defined?( ::Development::RequireMock ).should == 'constant'
    
  end

  it 'hooks require for enable-all' do
    
    ::Development.parse_configuration_expression( '+directory_name ./spec' )
    ::Development.parse_configuration_expression( '@directory_name' )
    ::Development.parse_configuration_expression( '!enable' )
    
    defined?( ::Development::OtherRequireMock ).should == nil
    require 'other_require_mock'
    defined?( ::Development::OtherRequireMock ).should == 'constant'
    
  end
  
end

