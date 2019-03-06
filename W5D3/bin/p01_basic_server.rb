require 'rack'
app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'

  if req.path == '/i/love/app/academy'
    # @controller = ControllerBase.new(req, res)
    res.write('/i/love/app/academy')
    # @controller.render_content('/i/love/app/academy')
  end 
#   res.write("Hello world!")
  res.finish
end
Rack::Server.start(
  app: app,
  Port: 3000
)