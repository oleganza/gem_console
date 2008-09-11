require 'irb'

class ::Object
  # Typical bin/*console content which we are going to extract:
  #
  # #!/usr/bin/env ruby
  # development_lib = File.join(File.dirname(__FILE__), '..', 'lib')
  # if File.exists?(development_lib + '/emrpc.rb')
  #   $LOAD_PATH.unshift(development_lib).uniq!
  # else
  #   require 'rubygems'
  # end
  # 
  # require 'emrpc'
  # require 'emrpc/console'
  # 
  # include EMRPC::Console
  # IRB.start
  #
  def gem_console(project_name, console_name = 'console')
    project_name = project_name.to_s.sub(/\.rb$/,'')
    project_name_rb = "#{project_name}.rb"
    
    # emulate __FILE__ on another level
    __file__ = (caller.size > 1 ? caller[-2] : caller[-1])[/^([^:]+)/]
    devlib = File.expand_path(File.join(File.dirname(__file__), '..', 'lib'))
    if File.exists?(File.join(devlib, project_name_rb))
      $LOAD_PATH.unshift(devlib).uniq!
    else
      require 'rubygems'
    end
    
    require project_name
    require "#{project_name}/#{console_name}"
    include(GemConsole[console_name])
    IRB.start
  end
end

module GemConsole
  VERSION = "1.0"
  
  def setup
    # user's code might do something useful here
  end
  
  # default project name with placeholders
  def project_name
    "$PROJECT_NAME v.$PROJECT_VERSION"
  end
  
  def greet
    puts "#{project_name} ('help!' for more info)"
  end
  
  def help!
    lines = gem_console_help
    puts ""
    aligned_table(lines).each do |line|
      print "  "
      puts line
    end
    puts ""
    nil
  end
  
  def aligned_table(tsv)
    splitted_lines = tsv.map do |line|
      cols = line.split("\t")
    end
    #p splitted_lines
    widths = splitted_lines.inject([]) do |ws, cols|
      #p "For cols: #{cols.inspect} (ws = #{ws.inspect})"
      cols.map{|c|c.size}.zip(ws).map do |total_local|
        total_local[1] = total_local.map{|i|i.to_i}.max
        total_local
      end.map do |pair|
        pair[1]
      end
    end
    #p widths
    lines_for_print = splitted_lines.map do |line|
      line.zip(widths).map do |(data, width)|
        data.ljust(width.to_i)
      end.join(" ")
    end
  end
  
  class <<self
    def included(mod)
      mod.extend(ClassMethods)
      mod.console_config = self
      self["__last_included__"] = mod
    end
  
    def [](name)
      @modules ||= {}
      @modules[name.to_s] || @modules["__last_included__"]
    end

    def []=(name, mod)
      @modules ||= {}
      @modules[name.to_s] = mod
    end
  end
  
  module ClassMethods
    attr_accessor :console_name, :console_config, :gem_console_help
    
    def included(root)
      return if @root == root
      @root = root
      console_module = self
      root.module_eval do
        include console_module
      end
      gem_console_help = @gem_console_help
      root.send(:define_method, :gem_console_help) do 
        gem_console_help
      end
      root.setup
      root.greet
    end
    
    def console_name(n = nil)
      n ? self.console_name = n : @console_name
    end
    
    def console_name=(n)
      console_config[n] = self
      @console_name = n
    end
    
    def help(*args)
      @gem_console_help ||= []
      @gem_console_help << args.map{|a|a.to_s}.join("\t") unless args.empty?
      @gem_console_help
    end
  end
end
