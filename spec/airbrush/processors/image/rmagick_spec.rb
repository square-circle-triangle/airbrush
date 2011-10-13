require File.dirname(__FILE__) + '/../../../spec_helper.rb'
require 'RMagick'

describe Airbrush::Processors::Image::Rmagick do

  before do
    @image = 'image'
    @columns = 1500; @rows = 1000
    @blob = 'blob'

    @rm_image = mock(Object)
    @rm_image.stub!(:change_geometry).and_return
    @rm_image.stub!(:crop!).and_return
    @rm_image.stub!(:crop_resized!).and_return
    @rm_image.stub!(:resize!).and_return
    @rm_image.stub!(:ensure_rgb!).and_return
    @rm_image.stub!(:to_blob).and_return(@blob)
    @rm_image.stub!(:format).and_return('JPEG')
    @rm_image.stub!(:format=).and_return('JPEG')
    @rm_image.stub!(:columns).and_return(@columns)
    @rm_image.stub!(:rows).and_return(@rows)
    Magick::Image.stub!(:from_blob).and_return([@rm_image])

    @processor = Airbrush::Processors::Image::Rmagick.new
  end

  describe 'when resizing' do

    it 'should auto calculate width/height when passed a single value' do
      Magick::Image.should_receive(:from_blob).and_return([@rm_image])
      @processor.should_receive(:calculate_dimensions).with(@image, 300).and_return([300,200])

      @processor.resize @image, 300
    end

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
      @processor.resize(@image, 300, 200).should == { :format => "JPEG", :image => "blob", :height => 1000, :width => 1500 }
    end

  end

  describe 'when cropping' do

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
      @processor.crop(@image, 10, 10, 100, 100).should == { :format => "JPEG", :image => "blob", :height => 1000, :width => 1500 }
    end

  end

  describe 'when performing a resized crop' do

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
      @processor.crop_resize(@image, 75, 75).should == { :format => "JPEG", :image => "blob", :height => 1000, :width => 1500 }
    end

  end

  describe 'when generating previews' do

    it 'should change the geometry of the image' do
      @rm_image.should_receive(:crop_resized!).twice.and_return
      @processor.previews @image, { :small => [200,100], :large => [500,250] }
    end

    it 'should return the raw image data back to the caller' do
      @rm_image.should_receive(:to_blob).twice.and_return('blob')
      @processor.previews(@image, { :small => [200,100], :large => [500,250] }).should == {  :small=> { :format => "JPEG", :image => "blob", :height => 1000, :width => 1500 }, :large=> { :format => "JPEG", :image => "blob", :height => 1000, :width => 1500 }, :original => [1500, 1000] }
    end

  end
  
  describe 'crop_and_resize' do
    
    it 'should return an image with the specified sizes' do
      @processor.resized_crop_mask(@image, {:x => 0, :y => 0, :width => 800, :height => 800 }, { :width => 2890, :height => 1940 }).should == {
      	:format => "JPEG", :image => "blob", :width => 1500, :height => 1000}
      
    end
    
    it 'should return an image cropped to the crop marks' do
      @rm_image.should_receive(:crop!).with(0,20,800,900, true).once
      @processor.resized_crop_mask(@image, {:x => 0, :y => 20, :width => 800, :height => 900 }, { :width => 2890, :height => 1940 }).should == {
      	:format => "JPEG", :image => "blob", :width => 1500, :height => 1000}
    end 

    it 'should return the raw image data back to the caller' do
      @rm_image.should_receive(:resize!).with(2890,1940).once
      @processor.resized_crop_mask(@image, {:x => 0, :y => 0, :width => 800, :height => 800 }, { :width => 2890, :height => 1940 }).should == {
      	:format => "JPEG", :image => "blob", :width => 1500, :height => 1000}
    end  
  end
  
  describe "exif_data" do
    it "should return a hash of exif data for the image" do
      @rm_image.should_receive(:get_exif_by_entry).once.and_return([["Make", "Canon"], ["ShutterSpeedValue", "189/32"]])
      @processor.exif_data(@image).should == { "Make" => "Canon", "ShutterSpeedValue" => "189/32" }
    end
  end
   
  describe "get_format" do
	
	Airbrush::Processors::Image::Rmagick::VALID_OUTPUT_FORMATS.each do |valid_format|
	  	it "should not change the image format if it is a #{valid_format}" do
			@rm_image.should_receive(:format).and_return(valid_format)
			@processor.send(:get_format, @rm_image).should == valid_format
		end
	end

	it "should change the format to JPEG if a non valid return format is found" do
		['TIF', 'TIFF', 'PDF'].each do |bad_format|
			@rm_image.should_receive(:format).and_return(bad_format)
			@processor.send(:get_format, @rm_image).should == 'JPEG' 
		end
	end
  end


  describe 'dimension calculation' do

    it 'should automatically recognize images in portrait mode' do
      @processor.send(:calculate_dimensions, @rm_image, 300).should == [300,200]
    end

    it 'should automatically recognize images in landscape mode' do
      @rm_image.stub!(:columns).and_return(1000)
      @rm_image.stub!(:rows).and_return(1500)
      @processor.send(:calculate_dimensions, @rm_image, 300).should == [200,300]
    end

    it 'should automatically clip resizes if they are larger than the original' do
      @processor.send(:calculate_dimensions, @rm_image, 2000).should == [1500,1000]
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
