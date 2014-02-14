module Hummingbird
  module AR
    extend ActiveSupport::Concern
    #
    # class User < ActiveRecord::Base
    #    hummingbird :points , :processes => [:logs,:total,:badge]
    # end
    #
    module ClassMethods
      def hummingbird_process_get(process)
        return process if process.class.name == 'Class'
        return "Hummingbird::Process::#{process.to_s.strip.camelize}".constantize
      end

      def hummingbird name, options = {}
        name = name.to_s.strip.to_sym
        processes = [options[:processes] || []].flatten.collect do |process|
          klass = hummingbird_process_get(process)
          klass.init(self,name)
          klass
        end
        options[:processes] = processes

        class_eval <<-RUBY, __FILE__, __LINE__+1
          def #{name}_marker
            @__hummingbird_#{name} ||= Hummingbird::Base.new(self,#{name.inspect},#{options.inspect})
          end
RUBY
      end
    end
  end
end

ActiveRecord::Base.class_eval do 
  include Hummingbird::AR
end
