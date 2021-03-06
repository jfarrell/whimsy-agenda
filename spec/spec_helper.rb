#
# common test setup
#

ENV['RACK_ENV'] = 'test'
ENV['REMOTE_USER'] = 'test'
require 'capybara/rspec'
require_relative '../main'
Capybara.app = Sinatra::Application
Capybara.javascript_driver = :poltergeist

# only load poltergeist driver for JavaScript if phantomjs is available
if
  ENV['PATH'].split(File::PATH_SEPARATOR).any? do |path|
    File.exist? File.join(path, 'phantomjs')
  end
then
  require 'capybara/poltergeist'
end
