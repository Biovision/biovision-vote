$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "biovision/vote/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "biovision-vote"
  s.version     = Biovision::Vote::VERSION
  s.authors     = ["Maxim Khan-Magomedov"]
  s.email       = ["maxim.km@gmail.com"]
  s.homepage    = "https://github.com/Biovision/biovision-vote"
  s.summary     = "Voting functionality for biovision-based applications"
  s.description = "Voting functionality for biovision-based applications"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'biovision-base'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot_rails'
end
