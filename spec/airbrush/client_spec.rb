require File.dirname(__FILE__) + '/../spec_helper.rb'
require 'starling'

describe Airbrush::Client, 'job management' do

  before do
    @id = :id
    @command = :command
    @args = {}
    @results = { :results => 'results' }
    @queue = 'incoming'
    @response_timeout = 300
    @queue_validity = 900

    @server = mock(Starling)
    @server.stub!(:set).and_return
    @server.stub!(:get).and_return(@results)
    Starling.stub!(:new).and_return(@server)

    @host = 'host'
    @client = Airbrush::Client.new(@host, @queue, @response_timeout, @queue_validity)
  end

  describe 'when created' do

    it 'should support a configurable target memcache host' do
      @client.host.should == @host
    end

    it 'should support a configurable inbound queue name' do
      @client.incoming_queue.should == @queue
    end

    it 'should support a configurable target memcache host' do
      @client.response_timeout.should == @response_timeout
    end

    it 'should support a configurable queue validity' do
      @client.queue_validity.should == @queue_validity
    end

  end

  describe 'job management' do

    it 'should allow a job to be posted' do
      @client.should respond_to(:process)
    end

    it 'should allow access to the results returned by a job' do
      @client.process(@id, @command, @args).should == @results
    end

  end

  describe 'a posted job' do

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
      Airbrush::Client::DEFAULT_RESPONSE_TIMEOUT.should == 2.minutes
      Timeout.should_receive(:timeout).and_return
      @client.process(@id, @command)
    end

    it 'should add the job into the incoming process queue' do
      @server.should_receive(:set).with(@queue, { :id => @id, :command => @command, :args => @args }, @queue_validity, false)
      @client.process(@id, @command, @args)
    end

  end

end
