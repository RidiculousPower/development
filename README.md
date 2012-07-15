# Development #

http://rubygems.org/gems/development

# Summary #

Cause gem require to load a path other than the RubyGems installation.

# Description #

Intercept gem-require expression (require 'gem') and require version at alternative path (such as a development version).

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

## 2. Configure Which Gems Development Should Override ##

The primary interface to development is the **.development.rb** configuration file, which should be placed in the user's home directory.

I would make project-specific .development.rb files a requirement (to avoid accidentally enabling it) but I don't think there is a reliable way to find the project directory based on the require. If you know a way, please let me know!

### The .development.rb Configuration File ###

#### Short Example ####

The shortest possible example is a one-liner:

```ruby
enable! :parallel_ancestry => '~/Projects/rp/ruby/parallel_ancestry'
```

#### Extended Example ####

But other configuration possibilities are provided for more complex configurations:

```ruby
###
# Declare named locations to associate gems or gemsets with specific locations.
#   If a directory exists by name of gem or gemset it will be used automatically.
#   Otherwise the directory will have to be declared explicitly.
#
directory( :code, '~/Projects' )

###
# Paths can start with names of other paths.
#
directory( :ridiculous_power, :code, 'rp' )

directory( :ruby, :ridiculous_power, 'ruby' )
directory( :hooked_objects, :ruby, 'hooked_objects' )
directory( :compositing_objects, :ruby, 'compositing_objects' )

###
# Add gems or gemsets to directory.
#
directory( :ridiculous_power ).add( 'persistence', 'magnets' )

###
# Declare a gemset to group a set of gems and configure them by a single reference.
#
gemset( :ruby,                'module-cluster', 
                              'parallel_ancestry', 
                              'identifies_as' )

gemset( :hooked_objects,      'hash-hooked', 
                              'array-hooked', 
                              'array-sorted', 
                              'array-unique', 
                              'array-sorted-unique' )

gemset( :compositing_objects, 'hash-compositing', 
                              'array-compositing', 
                              'array-sorted-compositing', 
                              'array-unique-compositing', 
                              'array-sorted-unique-compositing' )

###
# Specify directory by gem or gemset.
#
gem( 'to_lambda' ).directory( :ruby )

###
# Enable all (no parameters) or specific gems.
#
enable! :ruby, :hooked_objects, :compositing_objects, :parallel_ancestry
```

## Bundler Usage ##

Development plays well with bundler. The only caveat is that you have to require Development before Bundler.require:

```ruby
require 'bundler'

begin ; require 'development' ; rescue LoadError ; end

Bundler.require
```

or

```ruby
begin ; require 'development' ; rescue LoadError ; end

require 'bundler'

Bundler.require
```


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
