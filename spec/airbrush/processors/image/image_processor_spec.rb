require File.dirname(__FILE__) + '/../../../spec_helper.rb'

describe Airbrush::Processors::Image::ImageProcessor, 'class' do
    
  it 'should define a default set of image preprocessors' do
    Airbrush::Processors::Image::ImageProcessor.preprocessors.should_not be_blank
  end
    
end

describe Airbrush::Processors::Image::ImageProcessor, 'when preprocessing' do
  
  before do
    @image = 'image'
    
    @preprocessor = mock(Object)
    @preprocessor.stub!(:process).and_return
    
    @processor = Airbrush::Processors::Image::ImageProcessor.new
    Airbrush::Processors::Image::ImageProcessor.preprocessors = [ @preprocessor ]
  end
    
  it 'should provide protected access to image preprocessors' do
    @processor.should respond_to(:preprocess)
  end
  
  it 'should invoke each preprocessor with the given image when requested' do
    @preprocessor.should_receive(:process).with(@image).and_return
    @processor.send :preprocess, @image
  end
  
end
