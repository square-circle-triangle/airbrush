#!/usr/bin/env ruby

require 'rubygems'
require 'active_support'

class File
  def self.obsolete?(filename)
    File.mtime(filename) < 1.day.ago
  end
end

Dir['*'].each do |filename|
  next if filename =~ /^airbrush/ # leave queue files alone
  File.delete filename if File.obsolete? filename
end
