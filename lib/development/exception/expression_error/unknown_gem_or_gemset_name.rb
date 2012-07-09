
class ::Development::Exception::ExpressionError::UnknownGemOrGemsetName < ::Development::Exception::ExpressionError

  ################
  #  initialize  #
  ################
  
  def initialize( gem_name, configuration_line_number )
    
    super( 'Unknown gem or gemset name "' << gem_name.to_s + '"', configuration_line_number )
    
  end
  
end
