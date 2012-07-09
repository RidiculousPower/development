
require 'date'

Gem::Specification.new do |spec|

  spec.name                      = 'development'
  spec.rubyforge_project         = 'development'
  spec.version                   = '1.0.1'

  spec.summary                   = 'Manage development contexts, particularly in the context of nested gem dependencies being developed side by side.'
  spec.description               = 'Sometimes problems in one gem under development only appear in the context of use in another gem. In these contexts it can be difficult to discern the particular problem case without diving into the code. When gems are nested in multiple levels of dependency, this can become quite frustrating; gem require paths have to be replaced with relative paths, sometimes in multiple places, and it becomes easy to forget that there are relative paths in code, resulting in production code with broken development paths accidentally left in. Development inserts itself in the require process and loads development paths instead of the gem requires used for production code. Which gems load development paths instead of gem requires is determined by a simple configuration file.'

  spec.authors                   = [ 'Asher' ]
  spec.email                     = 'asher@ridiculouspower.com'
  spec.homepage                  = 'http://rubygems.org/gems/development'

  spec.add_dependency            'array-unique'

  spec.date                      = ::Date.today.to_s
  
  spec.files                     = ::Dir[ '{lib,spec}/**/*',
                                          'README*', 
                                          'LICENSE*',
                                          'CHANGELOG*' ]

end
