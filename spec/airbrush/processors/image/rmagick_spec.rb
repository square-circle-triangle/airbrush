require File.dirname(__FILE__) + '/../../../spec_helper.rb'
require 'RMagick'

describe Airbrush::Processors::Image::Rmagick, 'class' do

  before do
    @image = 'image'

    @rm_image = mock(Object)
    @rm_image.stub!(:change_geometry).and_return
    @rm_image.stub!(:crop!).and_return
    @rm_image.stub!(:crop_resized!).and_return
    @rm_image.stub!(:ensure_rgb!).and_return
    @rm_image.stub!(:to_blob).and_return('blob')
    @rm_image.stub!(:format=).and_return('JPEG')

    @processor = Airbrush::Processors::Image::Rmagick.new
    @processor.stub!(:purify_image).and_return
    Magick::Image.stub!(:from_blob).and_return([@rm_image])
  end

  describe Airbrush::Processors::Image::Rmagick, 'when resizing' do

    it 'should preprocess images before resizing' do
      @processor.resize @image, 300, 200
    end

    it 'should change the geometry of the image' do
      @rm_image.should_receive(:change_geometry).and_return
      @processor.resize @image, 300, 200
    end

    it 'should convert images to rgb if required' do
      @rm_image.should_receive(:ensure_rgb!).and_return
      @processor.resize @image, 300, 200
    end

    it 'should return the raw image data back to the caller' do
      @rm_image.should_receive(:to_blob).and_return('blob')
      @processor.resize(@image, 300, 200).should == 'blob'
    end

  end

  describe Airbrush::Processors::Image::Rmagick, 'when cropping' do

    it 'should preprocess images before cropping' do
      @processor.crop @image, 10, 10, 100, 100
    end

    it 'should change the geometry of the image' do
      @rm_image.should_receive(:crop!).and_return
      @processor.crop @image, 10, 10, 100, 100
    end

    it 'should convert images to rgb if required' do
      @rm_image.should_receive(:ensure_rgb!).and_return
      @processor.resize @image, 300, 200
    end

    it 'should return the raw image data back to the caller' do
      @rm_image.should_receive(:to_blob).and_return('blob')
      @processor.crop(@image, 10, 10, 100, 100).should == 'blob'
    end

  end

  describe Airbrush::Processors::Image::Rmagick, 'when performing a resized crop' do

    it 'should preprocess images before resizing/cropping' do
      @processor.crop_resize @image, 75, 75
    end

    it 'should change the geometry of the image' do
      @rm_image.should_receive(:crop_resized!).and_return
      @processor.crop_resize @image, 75, 75
    end

    it 'should convert images to rgb if required' do
      @rm_image.should_receive(:ensure_rgb!).and_return
      @processor.resize @image, 300, 200
    end

    it 'should return the raw image data back to the caller' do
      @rm_image.should_receive(:to_blob).and_return('blob')
      @processor.crop_resize(@image, 75, 75).should == 'blob'
    end

  end

  describe Airbrush::Processors::Image::Rmagick, 'when generating previews' do

    it 'should change the geometry of the image' do
      @rm_image.should_receive(:crop_resized!).twice.and_return
      @processor.previews @image, { :small => [200,100], :large => [500,250] }
    end

    it 'should return the raw image data back to the caller' do
      @rm_image.should_receive(:to_blob).twice.and_return('blob')
      @processor.previews(@image, { :small => [200,100], :large => [500,250] }).should == { :small => 'blob', :large => 'blob'}
    end

  end

end

describe Magick::Image, 'when created' do

  before do
    @image = Magick::Image.new(200, 100)
  end

  it 'should be able to convert the profile to srgb when requested' do
    @image.should respond_to(:ensure_rgb!)
  end

end

describe Magick::Image, 'when converting images to sRGB' do

  before do
    @image = Magick::Image.new(200, 100)
    @image.stub!(:add_profile).and_return
  end

  it 'should return if the image is already in sRGB colour space' do
    @image.colorspace = Magick::RGBColorspace
    @image.should_not_receive(:add_profile)
    @image.ensure_rgb!
  end

  it 'should log a warning if a non CMYK/RGB image is encountered' do
    @image.colorspace = Magick::Rec709LumaColorspace
    @image.should_not_receive(:add_profile)
    @image.log.should_receive(:warn).and_return
    @image.ensure_rgb!
  end

  it 'should add a CMYK profile if the image does not have a profile and is in CMYK colour space' do
    @image.colorspace = Magick::CMYKColorspace
    @image.should_receive(:add_profile).twice.and_return
    @image.ensure_rgb!
  end

  it 'should add a sRGB profile if the image is in CMYK colour space' do
    @image.colorspace = Magick::CMYKColorspace
    @image.should_receive(:add_profile).with(Magick::Image::SCT_SRGB_ICC).and_return
    @image.ensure_rgb!
  end

end
