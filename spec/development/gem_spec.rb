
require_relative '../../lib/development.rb'

describe ::Development::Gem do
  
  ################
  #  initialize  #
  #  directory   #
  ################
  
  it 'can initialize without a directory' do
    
    gem_instance_without_directory = ::Development::Gem.new( :gem_name )
    gem_instance_without_directory.name.should == :gem_name
    gem_instance_without_directory.directory.should == nil
    
  end

  it 'can initialize with a directory' do
    
    gem_instance_with_directory = ::Development::Gem.new( :gem_name, 'some/path' )
    gem_instance_with_directory.name.should == :gem_name
    directory = gem_instance_with_directory.directory
    directory.name.should == :gem_name
    directory.path.should == ::File.expand_path( 'some/path' )
    
  end

  ################
  #  directory=  #
  ################
  
  it 'can set directy by name' do
    gem_instance_with_directory = ::Development::Gem.new( :gem_name, 'some/path' )
    directory = ::Development.directory( :directory_name, 'some/other/path' )
    gem_instance_with_directory.set_directory( :directory_name )
    gem_instance_with_directory.directory.should == directory
  end

  it 'can set directy by instance' do
    gem_instance_with_directory = ::Development::Gem.new( :gem_name, 'some/path' )
    directory = ::Development.directory( :directory_name, 'some/other/path' )
    gem_instance_with_directory.set_directory( directory )
    gem_instance_with_directory.directory.should == directory
  end

  ####################
  #  self.enable!    #
  #  self.disable!   #
  #  self.enabled?   #
  #  self.disabled?  #
  ####################
  
  it 'can enable and disable gems' do
    some_gem_instance = ::Development.gem( :some_gem )
    some_gem_instance.enabled?.should == false
    some_gem_instance.enable!
    some_gem_instance.enabled?.should == true
    some_gem_instance.disable!
    some_gem_instance.enabled?.should == false
  end
  
end
