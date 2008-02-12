require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Airbrush::Processors::ImageProcessor, 'abstract class' do
  
  before do
    @processor = Airbrush::Processors::ImageProcessor.new
  end
  
  it 'should provide access to image preprocessors'
  
end
