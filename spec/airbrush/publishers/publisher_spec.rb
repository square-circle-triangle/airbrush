require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Airbrush::Publishers::Publisher, 'when created' do
  
  before do
    @publisher = Airbrush::Publishers::Publisher.new
  end
  
  it 'should be able to create a unique name given an id' do
    @publisher.send(:unique_name, 'id').should == 'id'
  end
  
  it 'should accept a symbol as an id to make unique' do
    @publisher.send(:unique_name, :id).should == 'id'
  end
  
end