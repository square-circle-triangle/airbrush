require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Airbrush::Listeners::Listener, 'when created' do
  
  before do
    @listener = Airbrush::Listeners::Listener.new
  end
  
  it 'should provide access to the handler instance' do
    @listener.handler = Airbrush::Handler.new(mock(Airbrush::Processors::Processor), mock(Airbrush::Publishers::Publisher))
    @listener.handler.should_not be_nil
  end
  
  it 'should raise an error if start is attempted (since its an abstract class)' do
    lambda { @listener.start }.should raise_error
  end
  
end