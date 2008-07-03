require File.dirname(__FILE__) + '/../../spec_helper.rb'

class MyProcessor < Airbrush::Processors::Processor

  def my_action(one, two, three = '3')
    [ one, two, three ]
  end

end

describe Airbrush::Processors::Processor, 'abstract class' do

  before do
    @processor = Airbrush::Processors::Processor.new
  end

  it 'should return an error from dispatch if the requested command is not implemented by the processor' do
    @processor.dispatch(:blah, {}).should == { :exception => "ERROR: Received error during processor dispatch for command 'blah' ()", :message => 'Unknown processor operation blah ()' }
  end

end

describe Airbrush::Processors::Processor, 'argument handling' do

  before do
    @processor = MyProcessor.new
  end

  it 'should inspect the target action for its parameters and assign them via the argument hash' do
    params = @processor.send :assign, :my_action, { :one => 'a', :two => 'b', :three => 'c' }
    params.should == %w( a b c )
  end

  it 'should respect default values when present in action signatures, but not in the argument hash' do
    params = @processor.send :assign, :my_action, { :one => 'a', :two => 'b' }
    params.should == %w( a b 3 )
  end

  it 'should raise an error if an action signature value is missing from the argument hash and does not have a default value' do
    lambda { @processor.send(:assign, :my_action, { :one => 'a' }) }.should raise_error
  end

end

describe Airbrush::Processors::Processor, 'when processing' do

  before do
    @processor = MyProcessor.new
  end

  it 'should invoke the requested target action' do
    @processor.dispatch(:my_action, { :one => 'a', :two => 'b' }).should == %w( a b 3 )
  end
end

describe Airbrush::Processors::Processor, 'error handling' do

  before do
    @error = 'an error string'
    @processor = MyProcessor.new
    @processor.stub!(:my_action).and_raise(@error)
  end

  it 'should return an error from dispatch if the requested command raises an exception during processing' do
    @processor.should_receive(:my_action).and_raise(@error)
    @options = { :one => 'a', :two => 'b', :three => 'c' }
    @processor.dispatch(:my_action, @options).should == { :exception => "ERROR: Received error during processor dispatch for command 'my_action' (#{@options.inspect})", :message => @error }
  end

end

class FilteredProcessor < Airbrush::Processors::Processor
  filter_params :password

  def command(username, password); 'no op'; end
end

class ExtraFilteredProcessor < Airbrush::Processors::Processor
  filter_params :username

  def command(username, password); 'no_op'; end
end

describe Airbrush::Processors::Processor, 'filter definitions' do

  before do
    @processor1 = FilteredProcessor.new
    @processor2 = ExtraFilteredProcessor.new
  end

  it 'should not override filters from other processors' do
    @processor1.filtered_params.should == [ :password ]
    @processor2.filtered_params.should == [ :username ]
  end

  describe 'filtering' do

    before do
      @params = { :username => 'username', :password => 'password' }
    end

    it 'should replace market parameter keys with a new value' do
      { @processor1 => :password, @processor2 => :username }.each do |processor, filtered|
        processor.send(:filter, @params).should == @params.update(filtered => '[FILTERED]')
      end
    end

  end

end
