
require_relative '../../lib/development.rb'

describe ::Development::Gemset do

  before :each do
    ::Development.clear
  end

  ################
  #  initialize  #
  #  name        #
  ################
  
  it 'can initialize with a name and a path' do
    gemset_instance = ::Development::Gemset.new( :name )
    gemset_instance.name.should == :name
  end

  ################
  #  directory=  #
  #  directory   #
  ################
  
  it 'can set a directory for all gems in set by name' do
    directory = ::Development.directory( :directory, 'some/path' )
    gemset_instance = ::Development::Gemset.new( :name )
    gemset_instance.set_directory( :directory )
    gemset_instance.directory.should == directory
  end

  it 'can set a directory for all gems in set by instance' do
    directory = ::Development.directory( :directory, 'some/path' )
    gemset_instance = ::Development::Gemset.new( :name )
    gemset_instance.set_directory( directory )
    gemset_instance.directory.should == directory
  end

  #############
  #  add      #
  #  members  #
  #############

  it 'can add gems by name that do not already exist in Development definition' do
    gemset_instance = ::Development::Gemset.new( :name )
    gemset_instance.add( :gem_name )
    gemset_instance.members.should == [ ::Development.get_gem( :gem_name ) ]
  end

  it 'can add gems by name that already exist in Development definition' do
    gemset_instance = ::Development::Gemset.new( :name )
    gem_instance = ::Development.gem( :gem_name )
    gemset_instance.add( :gem_name )
    gemset_instance.members.should == [ gem_instance ]
  end
  
  it 'can add gems that already exist in Development definition by instance' do
    gemset_instance = ::Development::Gemset.new( :name )
    gem_instance = ::Development.gemset( :gem_name )
    gemset_instance.add( gem_instance )
    gemset_instance.members.should == [ gem_instance ]
  end
  
  ############
  #  delete  #
  #  remove  #
  ############
  
  it 'delete and remove are aliases' do
    ::Development::Gemset.instance_method( :delete ) == ::Development::Gemset.instance_method( :remove )
  end
  
  it 'can delete a gem by instance' do
    gemset_instance = ::Development::Gemset.new( :name )
    gem_instance = ::Development.gemset( :gem_name )
    gemset_instance.add( :gem_name )
    gemset_instance.delete( gem_instance )
    gemset_instance.members.should == [ ]
  end

  it 'can delete a gem by name' do
    gemset_instance = ::Development::Gemset.new( :name )
    gem_instance = ::Development.gemset( :gem_name )
    gemset_instance.add( :gem_name )
    gemset_instance.delete( :gem_name )
    gemset_instance.members.should == [ ]
  end

  ####################
  #  self.enable!    #
  #  self.disable!   #
  #  self.enabled?   #
  #  self.disabled?  #
  ####################
  
  it 'can enable and disable all gems and general load path searching' do
    some_gemset_instance = ::Development.gemset( :some_gemset )
    some_gemset_instance.enabled?.should == false
    some_gemset_instance.enable!
    some_gemset_instance.enabled?.should == true
    some_gemset_instance.disable!
    some_gemset_instance.enabled?.should == false
  end
  
end
