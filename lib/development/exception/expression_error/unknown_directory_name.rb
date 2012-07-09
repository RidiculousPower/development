
class ::Development::Exception::ExpressionError::UnknownDirectoryName < ::Development::Exception::ExpressionError

  ################
  #  initialize  #
  ################
  
  def initialize( named_directory_name, configuration_line_number )
    
    super( 'Unknown named directory "' << named_directory_name.to_s + '"', configuration_line_number )
    
  end
  
end
