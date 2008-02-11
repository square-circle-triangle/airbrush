require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Airbrush::Handler, 'during creation' do
  
  it 'should raise an error if given a nil processor' do
    lambda { Airbrush::Handler.new(nil, Airbrush::Publishers::Publisher.new) }.should raise_error
  end
  
  it 'should raise an error if given a nil publisher' do
    lambda { Airbrush::Handler.new(Airbrush::Processors::Processor.new, nil) }.should raise_error
  end
  
end

describe Airbrush::Handler, 'when processing a request' do
  
  before do
    @processor = mock(Airbrush::Processors::Processor)
    @processor.stub!(:dispatch).and_return(true)
    
    @publisher = mock(Airbrush::Publishers::Publisher)
    @publisher.stub!(:publish).and_return
    
    @handler = Airbrush::Handler.new(@processor, @publisher)
    
    @id = 'id'
    @command = :command
    @args = {}    
  end
  
  it 'should pass the request to the processor' do
    @processor.should_receive(:dispatch).with(@command, @args).and_return(true)
    @handler.process @id, @command, @args
  end
  
  it 'should publish the processors result' do
    @publisher.should_receive(:publish).with(@id, true).and_return
    @handler.process @id, @command, @args
  end
  
  it 'should handle errors raised from the processor gracefully'
  it 'should handle errors raised from the publisher gracefully'
  
end