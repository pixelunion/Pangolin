# Theme Metadata
set :theme,         "Pangolin Skeleton"
set :version,       "v0.0.0"
set :style_url,     "http://static.tumblr.com/ymcvd4r/2Nvn1kcrj/style.css"
set :script_url,    "http://static.tumblr.com/ymcvd4r/HSAn1kcr2/script.js"

# Marketing Metadata
set :developer_name, "Pixel Union"
set :developer_url,  "https://www.pixelunion.net"
set :purchase_url,   "https://www.tumblr.com/theme/example"
set :demo_url,       "https://example.tumblr.com/"
set :marketing_url,  "http://cdn.pixelunion.net/customize/pxucm.js"

# Set environment asset host
if ENV["TUMBLR_DEV_HOST"]
  set :local_asset_host, ENV["TUMBLR_DEV_HOST"]
else
  set :local_asset_host, "localhost"
end

# Require Compass normalize
require 'compass-normalize'
compass_config do |config|
end

# Set the Slim output to pretty
set :slim, :pretty => true

# Ignore stuff we don't need.
ignore '/images/*.psd'
ignore '/scripts/libs/*'
ignore '/scripts/plugins/*'
ignore '/scripts/plugins.js'
ignore '/scripts/Theme/*'
ignore '/scripts/Theme.js.coffee'
ignore '/scripts/theme.js'
ignore '/scripts/external-feeds/*'
ignore '/index.html'

# Production build.
proxy "/#{theme.downcase.gsub(/ /, '-')}-#{version}.html", "/index.html", :locals => { :development => false }
# Development build.
proxy "/development.html", "/index.html", :locals => { :development => true }

require "lib/theme_helpers"
helpers ThemeHelpers

set :css_dir, 'styles'
set :js_dir, 'scripts'
set :images_dir, 'images'

configure :build do
  activate :minify_css
  activate :minify_javascript

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher
end
