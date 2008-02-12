require File.dirname(__FILE__) + '/../../../spec_helper.rb'
require 'RMagick'

describe Airbrush::Processors::Image::Rmagick, 'class' do
  
  before do
    @image = 'image'
  
    @rm_image = mock(Object)
    @rm_image.stub!(:change_geometry).and_return
    @rm_image.stub!(:crop).and_return
    @rm_image.stub!(:crop_resized!).and_return
    @rm_image.stub!(:to_blob).and_return('blob')
  
    @processor = Airbrush::Processors::Image::Rmagick.new
    Magick::Image.stub!(:from_blob).and_return([@rm_image])
  end
  
  describe Airbrush::Processors::Image::Rmagick, 'when resizing' do
  
    it 'should preprocess images before resizing' do
      @processor.dispatch :resize, :image => @image, :width => 300, :height => 200
    end

    it 'should change the geometry of the image' do
      @rm_image.should_receive(:change_geometry).and_return
      @processor.dispatch :resize, :image => @image, :width => 300, :height => 200
    end

    it 'should change return the raw image data back to the caller' do
      @rm_image.should_receive(:to_blob).and_return('blob')
      @processor.dispatch :resize, :image => @image, :width => 300, :height => 200
    end
  
  end

  describe Airbrush::Processors::Image::Rmagick, 'when cropping' do
  
    it 'should preprocess images before cropping' do
      @processor.dispatch :crop, :image => @image, :tl_x => 10, :tl_y => 10, :br_x => 100, :br_y => 100
    end
  
    it 'should change the geometry of the image' do
      @rm_image.should_receive(:crop).and_return
      @processor.dispatch :crop, :image => @image, :tl_x => 10, :tl_y => 10, :br_x => 100, :br_y => 100
    end

    it 'should change return the raw image data back to the caller' do
      @rm_image.should_receive(:to_blob).and_return('blob')
      @processor.dispatch :crop, :image => @image, :tl_x => 10, :tl_y => 10, :br_x => 100, :br_y => 100
    end
  
  end

  describe Airbrush::Processors::Image::Rmagick, 'when performing a resized crop' do
  
    it 'should preprocess images before resizing/cropping' do
      @processor.dispatch :crop_resized, :image => @image, :width => 75, :height => 75
    end
  
    it 'should change the geometry of the image' do
      @rm_image.should_receive(:crop_resized!).and_return
      @processor.dispatch :crop_resized, :image => @image, :width => 75, :height => 75
    end

    it 'should change return the raw image data back to the caller' do
      @rm_image.should_receive(:to_blob).and_return('blob')
      @processor.dispatch :crop_resized, :image => @image, :width => 75, :height => 75
    end
  
  end

  
end