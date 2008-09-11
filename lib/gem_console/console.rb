module GemConsole
  module X
    def y
      :y
    end
  end
  
  module Console
    include GemConsole
    
    help :my_method, "Call ma metha, bro!"
    help :exit,      "Exit, bro!"
    
    def project_name
      "#{GemConsole} v.#{GemConsole::VERSION}"
    end
    
    def setup
      puts "setting up..."
      $config = { :gem_console => :cool }
      include X
    end
    
    # other methods to be available in the IRB session
    def my_method
    end
  end
end
