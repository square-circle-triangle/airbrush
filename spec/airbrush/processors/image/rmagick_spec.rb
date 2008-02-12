require File.dirname(__FILE__) + '/../../../spec_helper.rb'

describe Airbrush::Processors::Image::Rmagick, 'class' do
  
  before do
    @image = 'image'
  
    @rm_image = mock(Object)
    @rm_image.stub!(:change_geometry).and_return
    @rm_image.stub!(:crop).and_return
    @rm_image.stub!(:crop_resized!).and_return
    @rm_image.stub!(:to_blob).and_return('blob')
  
    @processor = Airbrush::Processors::Image::Rmagick.new
    @processor.stub!(:create_image).and_return(@rm_image)
  end
  
  describe Airbrush::Processors::Image::Rmagick, 'when resizing' do
  
    it 'should preprocess images before resizing' do
      @processor.should_receive(:create_image).and_return(@rm_image)
      @processor.resize @image, 300, 200
    end
  
    it 'should change the geometry of the image' do
      @rm_image.should_receive(:change_geometry).and_return
      @processor.resize @image, 300, 200
    end

    it 'should change return the raw image data back to the caller' do
      @rm_image.should_receive(:to_blob).and_return('blob')
      @processor.resize @image, 300, 200
    end
  
  end

  describe Airbrush::Processors::Image::Rmagick, 'when cropping' do
  
    it 'should preprocess images before cropping' do
      @processor.should_receive(:create_image).and_return(@rm_image)
      @processor.crop @image, 10, 10, 100, 100
    end
  
    it 'should change the geometry of the image' do
      @rm_image.should_receive(:crop).and_return
      @processor.crop @image, 10, 10, 100, 100
    end

    it 'should change return the raw image data back to the caller' do
      @rm_image.should_receive(:to_blob).and_return('blob')
      @processor.crop @image, 10, 10, 100, 100
    end
  
  end

  describe Airbrush::Processors::Image::Rmagick, 'when performing a resized crop' do
  
    it 'should preprocess images before resizing/cropping' do
      @processor.should_receive(:create_image).and_return(@rm_image)
      @processor.crop_resized @image, 75, 75
    end
  
    it 'should change the geometry of the image' do
      @rm_image.should_receive(:crop_resized!).and_return
      @processor.crop_resized @image, 75, 75
    end

    it 'should change return the raw image data back to the caller' do
      @rm_image.should_receive(:to_blob).and_return('blob')
      @processor.crop_resized @image, 75, 75
    end
  
  end

  
end