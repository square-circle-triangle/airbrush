require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe 'log statements' do

  before do
    @time = Time.now
    Time.stub!(:now).and_return(@time)
    @target = StringIO.new
    @logger = Object.log(@target)
    @statement = 'this is a test'
  end

  it 'should automatically include the current time' do
    @logger.debug(@statement)
    @target.rewind
    @target.readline.should == "#{@time}: #{@statement}\n"
  end

end
