require File.dirname(__FILE__) + '/../../../spec_helper.rb'

class MyProcessor < Airbrush::Processors::Image::ImageProcessor
  before_filter :before
  after_filter :after
  
  def command(args = {}) # no op
  end
end

describe Airbrush::Processors::Image::ImageProcessor, 'when dispatching' do
  
  before do
    @args = {}
    @processor = MyProcessor.new
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
