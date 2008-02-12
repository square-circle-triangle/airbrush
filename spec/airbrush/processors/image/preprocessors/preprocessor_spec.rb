require File.dirname(__FILE__) + '/../../../../spec_helper.rb'

describe Airbrush::Processors::Image::Preprocessors::Preprocessor, 'abstract classs' do
  
  before do
    @processor = Airbrush::Processors::Image::Preprocessors::Preprocessor.new
  end

  it 'should fail if a concrete class does not define a #process implementation' do
    lambda { @processor.process }.should raise_error
  end

end
