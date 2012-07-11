
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

gemset( :ridiculous_power,    'persistence', 
                              'magnets' )

###
# Declare named locations to associate gems or gemsets with specific locations.
#   If a directory exists by name of gem or gemset it will be used automatically.
#   Otherwise the directory will have to be declared explicitly.
#

directory( :code, '~/Projects' )
directory( :ridiculous_power, :code, 'rp' )
directory( :ruby, :ridiculous_power, 'ruby' )
directory( :hooked_objects, :ruby, 'hooked_objects' )
directory( :compositing_objects, :ruby, 'compositing_objects' )

enable! :ruby, :hooked_objects, :compositing_objects
