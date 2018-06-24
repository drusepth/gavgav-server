require 'rack'
require 'pry'
require 'erb'

require_relative 'gavgav-engine/controller'
require_relative 'gavgav-engine/model'
require_relative 'gavgav-engine/router'

app = Proc.new do |env|
    [
      '200',
      { 'Content-Type' => 'text/html' },
      [ Router.route(env['PATH_INFO']) ]
    ]
end

Rack::Handler::WEBrick.run app
