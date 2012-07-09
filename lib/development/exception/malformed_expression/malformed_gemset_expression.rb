
class ::Development::Exception::MalformedExpression::MalformedGemsetExpression < 
      ::Development::Exception::MalformedExpression

  ################
  #  initialize  #
  ################
  
  def initialize( expression_string, configuration_line_number )
    
    super( 'gemset', expression_string, configuration_line_number )
    
  end
  
end
