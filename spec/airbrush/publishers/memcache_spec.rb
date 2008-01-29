require File.dirname(__FILE__) + '/../../spec_helper.rb'
require 'starling'

describe Airbrush::Publishers::Memcache, 'when created' do
  
  before do
    @memcache = Airbrush::Publishers::Memcache.new
  end

  it 'should configure access to the remote memcache server host' do
    @memcache.host.should_not be_nil
  end
  
  # future
  it 'should accept a configurable memcache host'
  
end

describe Airbrush::Publishers::Memcache, 'when publishing' do
  
  before do
    @server = mock(MemCache)
    @server.stub!(:set).and_return
    MemCache.stub!(:new).and_return(@server)
    @results = "results"
    
    @memcache = Airbrush::Publishers::Memcache.new
  end

  it 'should connect to the remote memcache server' do
    MemCache.should_receive(:new).and_return(@server)
    @memcache.publish(@results)
  end
  
  it 'should calculate a unique memcache queue name for publishing results'
  
  it 'should publish the given results to the remote memcache server' do
    @server.should_receive(:set).with('my result', @results).and_return
    @memcache.publish(@results)
  end
  
end