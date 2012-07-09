
class ::Development::Exception::MalformedExpression::MalformedGeneralDirectoryExpression < 
      ::Development::Exception::MalformedExpression

  ################
  #  initialize  #
  ################
  
  def initialize( expression_string, configuration_line_number )
    
    super( 'general directory', expression_string, configuration_line_number )
    
  end
  
end
