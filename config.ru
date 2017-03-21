require 'rack'
require 'rack/cache'

require "rack/cors"

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :options, :head], expose: ['ETag', "Link"]
  end
end

require './site/app'

run MicroAuthority