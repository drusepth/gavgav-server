require 'rack'
require 'pry'
require 'erb'

require_relative 'gavgav-engine/controller'

# require_relative stuff

class Router
  DEVELOPMENT_MODE = true

  def self.route(path)
    # /my/test/cool/foo should instantiate CoolController in controllers/my/test/cool_controller.rb, which has method foo on it
    _, *controller_path, receiving_method = path.split('/')

    controller = instantiate_receiving_controller(controller_path)
    return render_404 unless controller

    controller_response = controller.new.send(receiving_method)
    controller_response_binding = create_erb_binding_from(controller_response)

    view_template_source = File.read("views/#{controller_path.join('/')}/#{receiving_method}.html.erb")
    erb_renderer = ERB.new(view_template_source)

    erb_renderer.result(controller_response_binding)
  end

  private

  def self.render_404
    '404'
  end

  def self.instantiate_receiving_controller controller_path
    require_relative "controllers/#{controller_path.join('/')}_controller.rb"
    Object.const_get("#{controller_path.last.capitalize}Controller")

  rescue LoadError => e
    raise e if DEVELOPMENT_MODE
    nil # *_controller.rb not found

  rescue NameError => e
    raise e if DEVELOPMENT_MODE
    nil # *Controller undefined
  end

  def self.create_erb_binding_from(hash_obj)
    our_binding = binding
    hash_obj.each do |key, value|
      our_binding.local_variable_set(key.to_sym, value)
    end
    our_binding
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