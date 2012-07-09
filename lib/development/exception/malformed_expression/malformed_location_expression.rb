
class ::Development::Exception::MalformedExpression::MalformedLocationExpression < 
      ::Development::Exception::MalformedExpression

  ################
  #  initialize  #
  ################
  
  def initialize( expression_string, configuration_line_number )
    
    super( 'location', expression_string, configuration_line_number )
    
  end
  
end
