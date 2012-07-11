
require_relative '../../lib/development.rb'

describe ::Development::Directory do

  before :each do
    ::Development.clear
  end

  ################
  #  initialize  #
  #  name        #
  #  path        #
  ################
  
  it 'can initialize with a name and a path' do
    directory = ::Development::Directory.new( :name, 'some/path' )
    directory.name.should == :name
    directory.path.should == ::File.expand_path( 'some/path' )
  end

  ###########
  #  path=  #
  ###########
  
  it 'can set the path' do
    directory = ::Development::Directory.new( :name, 'some/path' )
    directory.set_path( 'some/other/path' )
    directory.path.should == ::File.expand_path( 'some/other/path' )
  end

  #########
  #  add  #
  #########

  it 'can add gems by name that do not already exist in Development definition' do
    directory = ::Development::Directory.new( :name, 'some/path' )
    gem_instance = ::Development.gem( :gem_name )
    directory.add( :gem_name )
    directory.members.should == [ gem_instance ]
  end
  
  it 'can add gems that already exist in Development definition' do
    directory = ::Development::Directory.new( :name, 'some/path' )
    gem_instance = ::Development.gem( :gem_name )
    directory.add( gem_instance )
    directory.members.should == [ gem_instance ]
  end
  
  ############
  #  delete  #
  #  remove  #
  ############
  
  it 'delete and remove are aliases' do
    ::Development::Directory.instance_method( :delete ) == ::Development::Directory.instance_method( :remove )
  end
  
  it 'can delete a gem by instance' do
    directory = ::Development::Directory.new( :name, 'some/path' )
    gem_instance = ::Development.gem( :gem_name )
    directory.add( :gem_name )
    directory.delete( gem_instance )
    directory.members.should == [ ]
  end

  it 'can delete a gem by name' do
    directory = ::Development::Directory.new( :name, 'some/path' )
    gem_instance = ::Development.gem( :gem_name )
    directory.add( :gem_name )
    directory.delete( :gem_name )
    directory.members.should == [ ]
  end
  
end
