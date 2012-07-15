
require 'date'

Gem::Specification.new do |spec|

  spec.name                      = 'development'
  spec.rubyforge_project         = 'development'
  spec.version                   = '1.1.0'

  spec.summary                   = 'Cause gem require (require \'gem\') to load a path other than the RubyGems installation.'
  spec.description               = 'Intercept gem-require expression (require \'gem\') and require version at alternative path (such as a development version).'

  spec.authors                   = [ 'Asher' ]
  spec.email                     = 'asher@ridiculouspower.com'
  spec.homepage                  = 'http://rubygems.org/gems/development'

  spec.required_ruby_version     = ">= 1.9.1"

  spec.date                      = ::Date.today.to_s
  
  spec.files                     = ::Dir[ '{lib,spec}/**/*',
                                          'README*', 
                                          'LICENSE*',
                                          'CHANGELOG*' ]

end
