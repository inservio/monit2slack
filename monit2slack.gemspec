
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "monit2slack/version"

Gem::Specification.new do |spec|
  spec.name          = "monit2slack"
  spec.version       = Monit2Slack::VERSION
  spec.authors       = ["Nedim Hadzimahmutovic"]
  spec.email         = ["h.nedim@gmail.com"]

  spec.summary       = %q{Post monit status messages to Slack.}
  spec.description   = %q{Post monit status messages to Slack. If used implicitly, monit environment variables will be used to populate the messages sent to Slack}
  spec.homepage      = "https://github.com/inservio/monit2slack"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = %w(monit2slack)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "bundler", "~> 1.16"
  spec.add_dependency "slack-notifier"
end
