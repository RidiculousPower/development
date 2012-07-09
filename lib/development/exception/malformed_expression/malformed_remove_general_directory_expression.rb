
class ::Development::Exception::MalformedExpression::MalformedRemoveGeneralDirectoryExpression < 
      ::Development::Exception::MalformedExpression

  ################
  #  initialize  #
  ################
  
  def initialize( expression_string, configuration_line_number )
    
    super( 'remove general directory', expression_string, configuration_line_number )
    
  end
  
end
