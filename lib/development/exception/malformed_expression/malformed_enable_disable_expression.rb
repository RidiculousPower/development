
class ::Development::Exception::MalformedExpression::MalformedEnableDisableExpression < 
      ::Development::Exception::MalformedExpression

  ################
  #  initialize  #
  ################
  
  def initialize( expression_string, configuration_line_number )
    
    super( 'enable/disable', expression_string, configuration_line_number )
    
  end
  
end
