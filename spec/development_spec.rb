
require_relative '../lib/development.rb'

describe ::Development do

  before :each do
    ::Development.clear
  end

  ######################################################################################################################
  #   private ##########################################################################################################
  ######################################################################################################################
  
  #################################
  #  self.path_is_gem_directory?  #
  #################################

  it 'can find a gem name in a load path, meaning load path specifies the gem directory' do
    ::Development.path_is_gem_directory?( 'spec/mock/require_mock', 'require_mock' ).should == true
    ::Development.path_is_gem_directory?( 'spec/mock/require_mock-submock', 'require_mock/submock' ).should == true
  end

  #######################################
  #  self.path_contains_gem_directory?  #
  #######################################

  it 'can find a gem name at a load path, meaning load path specifies the directory holding gem directory' do
    ::Development.path_contains_gem_directory?( 'spec/mock', 'require_mock', 'require_mock' ).should == true
    ::Development.path_contains_gem_directory?( 'spec/mock', 'require_mock-submock', 'require_mock/submock' ).should == true
  end

  ###########################
  #  self.load_gem_in_path  #
  ###########################

  it 'can load a gem from a development path' do

    defined?( ::Development::RequireMock ).should == nil
    ::Development.load_gem_in_path( 'spec/mock/require_mock', 'require_mock' )
    defined?( ::Development::RequireMock ).should == 'constant'

    defined?( ::Development::RequireMock::SubMock ).should == nil
    ::Development.load_gem_in_path( 'spec/mock/require_mock-submock', 'require_mock/submock' )
    defined?( ::Development::RequireMock::SubMock ).should == 'constant'
    
  end

  ######################################################################################################################
  #   public ###########################################################################################################
  ######################################################################################################################
  
  ########################
  #  self.directory      #
  #  self.get_directory  #
  ########################
  
  it 'can declare directories' do
    
    directory = ::Development.directory( :name, 'some/path' )

    ::Development.directory( :name ).should == directory
    ::Development.get_directory( :name ).should == directory

    ::Development.directory( :name, 'some_other_path' ).should == directory
    ::Development.directory( :name ).should == directory
    directory.path.should == ::File.expand_path( 'some_other_path' )

  end

  ##################
  #  self.gem      #
  #  self.get_gem  #
  ##################
  
  it 'can declare gems' do
    gem_instance = ::Development.gem( :gem_name )
    ::Development.gem( :gem_name ).should == gem_instance
    ::Development.get_gem( :gem_name ).should == gem_instance
  end

  it 'can declare gems with a directory' do
    directory = ::Development.directory( :directory_name, 'some/path' )
    gem_instance = ::Development.gem( :gem_name, directory )
    ::Development.gem( :gem_name ).should == gem_instance
    ::Development.get_gem( :gem_name ).should == gem_instance
  end

  it 'can declare gems with a path' do
    gem_instance = ::Development.gem( :gem_name, 'some/path' )
    ::Development.gem( :gem_name ).should == gem_instance
    gem_instance.directory.path.should == ::File.expand_path( 'some/path' )
    ::Development.get_gem( :gem_name ).should == gem_instance
  end

  #####################
  #  self.gemset      #
  #  self.get_gemset  #
  #####################

  it 'can declare gemsets' do
    gemset_instance = ::Development.gemset( :gemset_name )
    ::Development.gemset( :gemset_name ).should == gemset_instance
    ::Development.get_gemset( :gemset_name ).should == gemset_instance
  end

  it 'can declare gemsets with a set of gems' do
    gemset_instance = ::Development.gemset( :gemset_name, :some_gem, :some_other_gem )
    ::Development.gemset( :gemset_name ).should == gemset_instance
    gemset_instance.members.should == [ ::Development.gem( :some_gem ), ::Development.gem( :some_other_gem ) ]
    ::Development.get_gemset( :gemset_name ).should == gemset_instance
  end
  
  ###################################
  #  self.general_load_path         #
  #  self.general_load_paths        #
  #  self.remove_general_load_path  #
  ###################################
  
  it 'can declare and remove general load paths' do
    ::Development.general_load_path( 'some/path' )
    ::Development.general_load_paths.should == [ ::File.expand_path( 'some/path' ) ]
    ::Development.remove_general_load_path( 'some/path' )
    ::Development.general_load_paths.should == [ ]
  end

  ####################
  #  self.enable!    #
  #  self.disable!   #
  #  self.enabled?   #
  #  self.disabled?  #
  ####################
  
  it 'can enable and disable gems' do
    some_gem_instance = ::Development.gemset( :some_gem )
    some_gem_instance.enabled?.should == false
    some_gemset_instance = ::Development.gemset( :some_gemset )
    some_gemset_instance.enabled?.should == false
    ::Development.enable!( :some_gem, :some_gemset )
    some_gemset_instance.enabled?.should == true
    some_gem_instance.enabled?.should == true
    ::Development.disable!( :some_gem )
    some_gem_instance.enabled?.should == false
    some_gemset_instance.enabled?.should == true
  end

  it 'can enable and disable all gems and general load path searching' do
    ::Development.enable!
    ::Development.enabled_for_all?.should == true
    ::Development.disable!
    ::Development.enabled_for_all?.should == false
    some_gem_instance = ::Development.gemset( :some_gem )
    some_gem_instance.enabled?.should == false
    some_gemset_instance = ::Development.gemset( :some_gem )
    some_gemset_instance.enabled?.should == false
    ::Development.enable!
    some_gem_instance.enabled?.should == true
    some_gemset_instance.enabled?.should == true
    ::Development.disable!
    some_gem_instance.enabled?.should == false
    some_gemset_instance.enabled?.should == false
  end
  
  it 'can enable a gem with a path using a hash' do
    ::Development.enable!( 'persistence' => '~/Projects/rp/persistence' )
    gem_instance = ::Development.gem( :persistence )
    gem_instance.name.should == :persistence
    gem_instance.directory.path.should == ::File.expand_path( '~/Projects/rp/persistence' )
    gem_instance.enabled?.should == true
  end
  
  ####################
  #  Object.require  #
  ####################

  it 'hooks require for registered gems' do
    
    ::Development.directory( :directory_name, './spec/mock' ).add( 'require_mock2' )
    ::Development.enable!( 'require_mock2' )
    
    defined?( ::Development::RequireMock2 ).should == nil
    require 'require_mock2'
    defined?( ::Development::RequireMock2 ).should == 'constant'
    
  end
  
  it 'hooks require for registered gems' do
    
    ::Development.directory( :directory_name, './spec/mock' ).add( 'require_mock3' )
    ::Development.enable!( 'require_mock3' )
    
    defined?( ::Development::RequireMock3 ).should == nil
    require 'require_mock3'
    defined?( ::Development::RequireMock3 ).should == 'constant'
    
  end

  it 'hooks require for enable-all' do
    
    ::Development.directory( :directory_name, './spec/mock' ).add( 'require_mock4' )
    ::Development.enable!
    
    defined?( ::Development::RequireMock4 ).should == nil
    require 'require_mock4'
    defined?( ::Development::RequireMock4 ).should == 'constant'
    
  end
  
end
