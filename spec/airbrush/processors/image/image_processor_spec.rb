require File.dirname(__FILE__) + '/../../../spec_helper.rb'

class MyImageProcessor < Airbrush::Processors::Image::ImageProcessor
  before_filter :before
  after_filter :after
  
  def command
    'no op'
  end
end

class MyExtraImageProcessor < Airbrush::Processors::Image::ImageProcessor
  before_filter :before_extra
  after_filter :after_extra
  
  def command
    'no op'
  end
end

describe Airbrush::Processors::Image::ImageProcessor, 'filter definitions' do
  
  before do
    @processor1 = MyImageProcessor.new
    @processor2 = MyExtraImageProcessor.new
  end
  
  it 'should not override filters from other processors' do
    @processor1.before_filters.should == [ :before ]
    @processor2.before_filters.should == [ :before_extra ]
    
    @processor1.after_filters.should == [ :after ]
    @processor2.after_filters.should == [ :after_extra ]
  end
  
end

describe Airbrush::Processors::Image::ImageProcessor, 'when dispatching' do
  
  before do
    @args = {}
    @processor = MyImageProcessor.new
    @processor.stub!(:filter_dispatch).and_return
  end
  
  it 'should invoke before filters before sending operation' do
    @processor.should_receive(:filter_dispatch).with(:before, @args).and_return
    @processor.dispatch :command, @args
  end
  
  it 'should invoke after filters after sending operation' do
    @processor.should_receive(:filter_dispatch).with(:after, @args).and_return
    @processor.dispatch :command, @args
  end
  
end
