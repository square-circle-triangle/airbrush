require File.dirname(__FILE__) + '/../../spec_helper.rb'
require 'starling'

describe Airbrush::Publishers::Memcache, 'when created' do
  
  before do
    @host = 'host'
    @memcache = Airbrush::Publishers::Memcache.new(@host)
  end

  it 'should configure access to the remote memcache server host' do
    @memcache.host.should == @host
  end  
  
end

describe Airbrush::Publishers::Memcache, 'when publishing' do
  
  before do
    @host = 'host'
    @server = mock(MemCache)
    @server.stub!(:set).and_return
    MemCache.stub!(:new).and_return(@server)
    @results = "results"
    @id = 'id'
    
    @memcache = Airbrush::Publishers::Memcache.new(@host)
    @memcache.stub!(:unique_name).and_return('unique')
  end

  it 'should connect to the remote memcache server' do
    MemCache.should_receive(:new).and_return(@server)
    @memcache.publish(@id, @results)
  end
  
  it 'should calculate a unique memcache queue name for publishing results' do
    @memcache.should_receive(:unique_name).with(@id).and_return('unique')
    @memcache.publish(@id, @results)
  end
  
  it 'should publish the given results to the remote memcache server' do
    @server.should_receive(:set).with('unique', @results).and_return
    @memcache.publish(@id, @results)
  end
  
end