require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Airbrush::Server, 'during creation' do
  
  it 'should accept an operating context' do
    context = Hash.new
    airbrush = Airbrush::Server.new(context)
    airbrush.should_not be_nil
  end
  
end

describe Airbrush::Server, 'when created' do
  
  before do
    @airbrush = Airbrush::Server.new
  end
  
  it 'should automatically create a memcache listener for incoming requests' do
    @airbrush.listener.class.should == Airbrush::Listeners::Memcache
  end
  
  it 'should automatically create a handler to handle incoming requests' do
    @airbrush.listener.handler.should_not be_nil
  end

  it 'should automatically configure the handler with an rmagick processor' do
    @airbrush.listener.handler.processor.class.should == Airbrush::Processors::Rmagick
  end
  
  it 'should automatically configure the handler with a memcache publisher' do
    @airbrush.listener.handler.publisher.class.should == Airbrush::Publishers::Memcache
  end

  # later when we work on option processing
  it 'should allow for configurable listeners'
  it 'should allow for configurable publishers'
  it 'should allow for configurable processors'
  
end

describe Airbrush::Server, 'when started' do
  
  before do
    @listener = mock(Airbrush::Listeners::Listener)
    @listener.stub!(:start).and_return
    @listener.stub!(:handler=).and_return
    Airbrush::Listeners::Memcache.stub!(:new).and_return(@listener)
    @airbrush = Airbrush::Server.new
  end
  
  it 'should start accepting incoming requests via the listener' do
    @listener.should_receive(:start).and_return
    @airbrush.start
  end
  
end
