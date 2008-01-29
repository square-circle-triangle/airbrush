require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Airbrush::Listeners::Listener, 'when created' do
  
  before do
    @listener = Airbrush::Listeners::Listener.new
  end
  
  it 'should provide access to the handler instance' do
    @listener.handler = Airbrush::Handler.new(mock(Airbrush::Processors::Processor), mock(Airbrush::Publishers::Publisher))
    @listener.handler.should_not be_nil
  end
  
end