require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Airbrush::Processors::Processor, 'when processing' do
  
  before do
    @processor = Airbrush::Processors::Processor.new
  end
  
  it 'should raise an error upon receiving method calls, since all operations are to be implemented in concrete classes' do
    lambda { @processor.send :blah }.should raise_error
  end

end