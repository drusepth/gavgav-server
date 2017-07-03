require 'rack'
require 'pry'
require 'erb'

# require_relative stuff

class Router
  def self.route(path)
    # /my/test/cool/foo should instantiate CoolController in controllers/my/test/cool_controller.rb, which has method foo on it
    _, *controller_path, receiving_method = path.split('/')

    controller = instantiate_receiving_controller(controller_path)
    controller_response_binding = controller.new.send(receiving_method)

    view_template_source = File.read("views/#{controller_path.join('/')}/#{receiving_method}.html.erb")
    erb_renderer = ERB.new(view_template_source)

    erb_renderer.result(controller_response_binding)
  end

  private

  def self.instantiate_receiving_controller controller_path
    require_relative "controllers/#{controller_path.join('/')}_controller.rb"
    Object.const_get("#{controller_path.last.capitalize}Controller")
  end
end

app = Proc.new do |env|
    [
      '200',
      { 'Content-Type' => 'text/html' },
      [ Router.route(env['PATH_INFO']) ]
    ]
end

Rack::Handler::WEBrick.run app