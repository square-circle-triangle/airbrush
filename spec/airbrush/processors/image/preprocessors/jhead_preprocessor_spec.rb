require File.dirname(__FILE__) + '/../../../../spec_helper.rb'

describe Airbrush::Processors::Image::Preprocessors::JheadPreprocessor, 'when created' do
  
  before do
    # somehow mock out system calls
  end

  it 'should raise and error if jhead is not installed'
  #   jhead_exists = system 'which jhead'
  #   
  #   if jhead_exists
  #     lambda { Airbrush::Processors::Image::Preprocessors::JheadPreprocessor.new }.should_not raise_error
  #   else
  #     lambda { Airbrush::Processors::Image::Preprocessors::JheadPreprocessor.new }.should raise_error
  #   end
  # end
  
end

describe Airbrush::Processors::Image::Preprocessors::JheadPreprocessor, 'when processing' do
  
  before do
    @image = 'image'
    @processor = Airbrush::Processors::Image::Preprocessors::JheadPreprocessor.new
  end

  it 'should run jhead over the original image' do
    @processor.should_receive(:system).with("jhead -purejpg #{@image}").and_return
    @processor.process(@image)
  end
  
end
