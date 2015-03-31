$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "kumquat/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "kumquat"
  s.version     = Kumquat::VERSION
  s.authors     = ["Fred Benenson"]
  s.email       = ["fred@kickstarter.com"]
  s.homepage    = "http://www.github.com/kickstarter/kumquat"
  s.summary     = "Kumquat is a tool for sending RMarkdown files over email."
  s.description = "Kumquat is a half-bacronym: Kickstarter Universal Management QUery Admin Tool"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"
  # s.add_dependency "jquery-rails", "~> 3.0.1"
  # s.add_dependency "jquery-ui-rails", "~> 3.0.1"

  s.add_development_dependency "configs"
  s.add_development_dependency 'mysql2', '~> 0.3.11'
end
