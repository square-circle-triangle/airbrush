require File.dirname(__FILE__) + '/../spec_helper.rb'
require 'starling'

describe Airbrush::Client, 'job management' do
  
  before do
    @id = :id
    @command = :command
    @args = {}
    @results = 'results'
    @queue = 'incoming'
    @timeout = 5.minutes
    
    @server = mock(Starling)
    @server.stub!(:set).and_return
    @server.stub!(:get).and_return('results')
    Starling.stub!(:new).and_return(@server)
    
    @host = 'host'
    @client = Airbrush::Client.new(@host, @queue, @timeout)
  end
  
  describe Airbrush::Client, 'when created' do
    
    it 'should support a configurable target memcache host' do
      @client.host.should == @host
    end

    it 'should support a configurable inbound queue name' do
      @client.incoming_queue.should == @queue
    end
    
    it 'should support a configurable target memcache host' do
      @client.timeout.should == @timeout
    end
    
  end
  
  describe Airbrush::Client, 'job management' do

    it 'should allow a job to be posted' do
      @client.should respond_to(:process)
    end
  
    it 'should allow access to the results returned by a job' do
      @client.process(@id, @command, @args).should == @results
    end
    
  end
  
  describe Airbrush::Client, 'a posted job' do
    
    it 'should raise an error if the id is not valid' do
      lambda { @client.process(nil, @command, @args) }.should raise_error
    end
  
    it 'should raise an error if the command is not valid' do
      lambda { @client.process(@id, nil, @args) }.should raise_error
    end
  
    it 'should raise an error if the args are not valid' do
      lambda { @client.process(@id, @command, nil) }.should raise_error
    end
  
    it 'should support optional arguments' do
      lambda { @client.process(@id, @command) }.should_not raise_error
    end
    
    it 'should time out after 2 minutes seconds of inactivity' do
      Airbrush::Client::DEFAULT_TIMEOUT_LENGTH.should == 2.minutes
      #@client.should_receive(:timeout).and_return # must check Timeout::timeout
      @client.process(@id, @command)
    end
    
  end
  
end