require File.dirname(__FILE__) + '/spec_helper.rb'

describe 'airbrush' do
  
  it 'should add a log method to object' do
    Object.should respond_to(:log)
  end
  
end
