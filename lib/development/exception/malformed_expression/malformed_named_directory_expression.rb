
class ::Development::Exception::MalformedExpression::MalformedNamedDirectoryExpression < 
      ::Development::Exception::MalformedExpression

  ################
  #  initialize  #
  ################
  
  def initialize( expression_string, configuration_line_number )
    
    super( 'named directory', expression_string, configuration_line_number )
    
  end
  
end
