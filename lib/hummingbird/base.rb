module Hummingbird
  class Base
    attr :name, :options, :object
    def initialize(obj,name,options={})
      options.symbolize_keys!
      @object = obj
      @name = name
      @options = options
    end

    def method_missing(method,*args,&blk)
      if  processes.keys.include?(method)
        processes[method].value
      else
        super(method,*args,&blk)
      end
    end

    def processes
      @processes ||= begin
                       h = ActiveSupport::OrderedHash.new
                       [@options[:processes] || []].flatten.each do |process|
                         p = find_process(process)
                         h[p.class.name.split("::").last.underscore.to_sym] = p
                       end
                       h
                     end
    end

    def find_process(process)
      return process.new(self) if process.class.name == 'Class'
      return "Hummingbird::Process::#{process.to_s.strip.camelize}".constantize.new(self)
    end

    def add(type=nil,point=0)
      processes.each do |k,process|
        process.add(type,point)
      end
    end
  end
end
