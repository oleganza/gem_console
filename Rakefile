require "rake"
require "rake/clean"
require "rake/gempackagetask"
require "rake/rdoctask"
require "rake/testtask"
require "spec/rake/spectask"
require "fileutils"

def __DIR__
  File.dirname(__FILE__)
end

include FileUtils
require 'lib/gem_console'

def sudo
  ENV['GC_SUDO'] ||= "sudo"
  sudo = windows? ? "" : ENV['GC_SUDO']
end

def windows?
  (PLATFORM =~ /win32|cygwin/) rescue nil
end

def install_home
  ENV['GEM_HOME'] ? "-i #{ENV['GEM_HOME']}" : ""
end

##############################################################################
# Packaging & Installation
##############################################################################
CLEAN.include ["**/.*.sw?", "pkg", "lib/*.bundle", "*.gem", "doc/rdoc", ".config", "coverage", "cache"]

desc "Run the specs."
task :default do
  sh 'spec spec'
end

task :gem_console => [:clean, :rdoc, :package]

RUBY_FORGE_PROJECT  = "gem_console"
PROJECT_URL         = "http://oleganza.com."
PROJECT_SUMMARY     = "Smart IRB console for Ruby libraries."
PROJECT_DESCRIPTION = PROJECT_SUMMARY

AUTHOR = "Oleg Andreev"
EMAIL  = "oleganza@gmail.com"

GEM_NAME    = "gem_console"
PKG_BUILD   = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''
GEM_VERSION = GemConsole::VERSION + PKG_BUILD

RELEASE_NAME    = "REL #{GEM_VERSION}"

require "extlib/tasks/release"

spec = Gem::Specification.new do |s|
  s.name         = GEM_NAME
  s.version      = GEM_VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = AUTHOR
  s.email        = EMAIL
  s.homepage     = PROJECT_URL
  s.summary      = PROJECT_SUMMARY
  s.bindir       = "bin"
  s.description  = s.summary
  s.executables  = %w( gem_console )
  s.require_path = "lib"
  s.files        = %w( README Rakefile MIT-LICENSE ) + Dir["{bin,spec,lib}/**/*"]

  # rdoc
  s.has_rdoc         = true
  s.extra_rdoc_files = %w( README MIT-LICENSE )

  s.required_ruby_version = ">= 1.8.4"
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc "Run :package and install the resulting .gem"
task :install => :package do
  sh %{#{sudo} gem install #{install_home} --local pkg/#{GEM_NAME}-#{GEM_VERSION}.gem --no-rdoc --no-ri}
end

desc "Run :clean and uninstall the .gem"
task :uninstall => :clean do
  sh %{#{sudo} gem uninstall #{GEM_NAME}}
end
