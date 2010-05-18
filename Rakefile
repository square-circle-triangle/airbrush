Dir['tasks/**/*.rake'].each { |rake| load rake }

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "airbrush"
    gemspec.summary = "Image Processing Server"
    gemspec.description = "An Image Processing Server"
    gemspec.email = "nick@whatevernext.org"
    gemspec.homepage = "http://github.com/square-circle-triangle/airbush"
    gemspec.authors = ["Marcus Crafter", "Nick Marfleet"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
