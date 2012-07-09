# Development #

http://rubygems.org/gems/development

# Summary #

Manage development contexts, particularly in the context of nested gem dependencies being developed side by side.

# Description #

Sometimes problems in one gem only appear in the context of use in another gem. In these contexts it can be difficult to discern the particular problem case without diving into the code. When gems are nested in multiple levels of dependency, this can become quite frustrating; gem require paths have to be replaced with relative paths, sometimes in multiple places, and it becomes easy to forget that there are relative paths in code, resulting in production code with broken development paths accidentally left in.

Development inserts itself in the require process and loads development paths instead of the gem requires used for production code. Which gems load development paths instead of gem requires is determined by a simple configuration file.

# Install #

* sudo gem install development

# Usage #

Enabling Development requires two things:

## 1. Require Development ##

```ruby
begin ; require 'development' ; rescue LoadError ; end
```

Or a multi-line version if you prefer:

```ruby
begin
  require 'development'
rescue LoadError
end
```

Doing this rather than simply requiring development ensures that Development can work transparently without requiring even a development dependency.

## 2. Configure Gems Development Should Intercept ##

The primary interface to development is the **.development** configuration file, which should be placed in the user's home directory.

I would make project-specific .development files a requirement (to avoid accidentally enabling it) but I don't think there is a reliable way to find the project directory based on the require. If you know a way, please let me know!

### Configuration File Example ###

	###
	# Ruby 'development' configuration file (.development).
	#
	# * # denotes comment.
	# * Indentation is treated as a line continuation.
	# * Items can be separated by , or simply by whitespace.
	# * Length of whitespace is irrelevant - contiguous whitespace is "one unit".
	#

	###
	# Any lines beginning with plain text (not =, +, -, @, !) will be interpreted as general directory expressions.
	# It is not necessary to specify any general directories. Multiple directories may be specified, one per line.
	#
	# Uncomment the line below to look for directories with gem name in ~/ruby_projects. Any directories specified
	# in this way will be used in the case that no explicit specification exists for gem name in question.
	#
	# ~/ruby_projects

	###
	# Declare a gemset to group a set of gems and configure them by a single reference.
	#
	# Gems are permitted to be in multiple sets, with first match (from top of .development file downward) winning.
	#
	# =<gemset_name> gem-name, ...
	#

	=ruby                 module-cluster

	=hooked_objects       hash-hooked 
	                      array-hooked 
	                      array-sorted 
	                      array-unique 
	                      array-sorted-unique

	=compositing_objects  hash-compositing
	                      array-compositing
	                      array-sorted-compositing
	                      array-unique-compositing
	                      array-sorted-unique-compositing

	=ridiculous_power     persistence
	                      magnets

	###
	# Declare named locations to associate gems or gemsets with specific locations.
	#
	# +directory_name path, ...
	#
	# Paths that begin with @ will interpolate the directory name as the starting portion of the path.
	#

	+code                 ~/Projects
	+ridiculous_power     @code/rp
	+ruby                 @ridiculous_power/ruby

	+hooked_objects       @ruby/hooked_objects
	+compositing_objects  @ruby/compositing_objects

	###
	# Declare lookup locations for specific gems.
	#
	# Named paths listed on there own 
	#

	@hooked_objects       hooked_objects
	@compositing_objects  compositing_objects

	@ridiculous_power     ridiculous_power

	###
	# !enable and !disable can be used to cause production gems to be used.
	# 
	# * !enable or !disable on its own will enable or disable all gems and change the default (enabled/disabled), 
	#   after which individual gems can be enabled or disabled.
	#
	# * !enable or !disable followed by a gem name or a gemset name will enable or disable that gem/gemset.
	#
	# Nothing is enabled to start. Call !enable to use .development specifications in all cases; after
	# !enable individual gems/sets/paths can be enabled/disabled.
	#

	!enable 

# License #

  (The MIT License)

  Copyright (c) Ridiculous Power, Asher

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  'Software'), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
