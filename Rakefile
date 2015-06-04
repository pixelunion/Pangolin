
require 'shellwords'

task :default => ["server"]

desc "run the development server"
task :server do
  sh "bundle exec middleman server"
end

desc "build all files, including assets"
task :build do
  sh "bundle exec middleman build"
end

desc "build only the production theme file"
task :build_production do
  sh "bundle exec middleman build -g *-v*.*.*.html"
end

desc "build the development theme file, and copy it to clipboard"
task :build_development do
  sh "bundle exec middleman build -g development.html && cat #{Shellwords.escape(File.dirname(__FILE__))}/build/development.html | pbcopy"
end

desc "automatically build the development file and copy it to the clipboard when any slim file is changed"
task :auto_build do
  sh "bundle exec guard"
end
