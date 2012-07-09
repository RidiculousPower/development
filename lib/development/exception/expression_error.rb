
class ::Development::Exception::ExpressionError < ::Exception
  
  ################
  #  initialize  #
  ################
  
  def initialize( exception_string, configuration_line_number )

    exception_string << ' on line ' << configuration_line_number.to_s << ' of configuration file' + 
                        ' (' + ::File.expand_path( '~/' + ::Development::ConfigurationFileName ) + 
                        ').'
    
    super( exception_string )

  end
  
end
