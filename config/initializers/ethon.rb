unless RUBY_PLATFORM =~ /arm64/
  require "typhoeus"
  Ethon.logger = Logger.new(nil) 
end
