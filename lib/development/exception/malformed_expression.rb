
class ::Development::Exception::MalformedExpression < ::Development::Exception::ExpressionError
  
  ################
  #  initialize  #
  ################
  
  def initialize( expression_name_string, expression_string, configuration_line_number )

    exception_string = 'Malformed ' << expression_name_string + ' expression "' << expression_string <<'"'
    
    super( exception_string, configuration_line_number )

  end
  
end
