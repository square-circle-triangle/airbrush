require File.dirname(__FILE__) + '/../../spec_helper.rb'
require 'starling'

describe Airbrush::Listeners::Memcache, 'initialization' do
  
  before do
    @host = 'host'
    @frequency = 5
  end
  
  describe Airbrush::Listeners::Memcache, 'when created' do
  
    before do
      @memcache = Airbrush::Listeners::Memcache.new(@host, @frequency)
    end
  
    it 'should configure access to the remote memcache server host' do
      @memcache.host.should == @host
    end
  
    it 'should configure the poll frequency time' do
      @memcache.poll_frequency.should == @frequency
    end
  
    # future
    it 'should accept a configurable incoming job queue name'
  
  end
  
  describe Airbrush::Listeners::Memcache, 'when started' do
  
    before do
      @op = { :command => :command, :args => {} }
      @server = mock(MemCache)
      @server.stub!(:get).and_return(@op)
      MemCache.stub!(:new).and_return(@server)
    
      @handler = mock(Airbrush::Handler)
      @handler.stub!(:process).and_return

      @memcache = Airbrush::Listeners::Memcache.new(@host)
      @memcache.handler = @handler
    end
  
    it 'should connect to the remote memcache server' # REVISIT: can't call start since it loops forever
  
    it 'should poll the remote memcache server for jobs' do
      @server.should_receive(:get).and_return(@op)
      @memcache.send :process, @server
    end
  
    it 'should sleep 2 seconds inbetween memcache server polls' # REVISIT: can't call start since it loops forever
  
    it 'should ensure remote jobs are contained inside a hash' do
      @server.stub!(:get).and_return("bad format")
      @handler.should_not_receive(:process)
      @memcache.send :process, @server
    end
  
    it 'should ensure remote jobs include a :command key' do
      @server.stub!(:get).and_return({})
      @handler.should_not_receive(:process)
      @memcache.send :process, @server
    end

    it 'should ensure remote jobs include an :args key' do
      @server.stub!(:get).and_return({:command => :command})
      @handler.should_not_receive(:process)
      @memcache.send :process, @server
    end
  
    it 'should log invalid jobs'
  
    it 'should ignore invalid jobs (ie. invalid jobs should not halt processing)' do
      @server.stub!(:get).and_return(nil)
      @handler.should_not_receive(:process)
    
      lambda { @memcache.send :process, @server }.should_not raise_error
    end
  
    it 'should pass valid jobs to the handler' do
      @server.stub!(:get).and_return(@op)
      @handler.should_receive(:process).with(@op[:command], @op[:args]).and_return
      @memcache.send :process, @server
    end
  
    it 'should log errors return from the handler'
    
    it 'should ignore errors returned from the handler (ie. errors raised from the handler should not halt processing)' do
      @server.stub!(:get).and_return(@op)
      @handler.stub!(:process).and_raise("Test Error")
    
      lambda { @memcache.send :process, @server }.should_not raise_error
    end
  
    # future
    it 'should accept a configurable poll time frequency'
    it 'should automatically discover the target memcache host address via dnssd'
  
  end
  
end