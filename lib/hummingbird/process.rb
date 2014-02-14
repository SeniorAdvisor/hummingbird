module Hummingbird
  module Process
    class Base
      attr_accessor :hummingbird
      def initialize(hummingbird)
        @hummingbird = hummingbird
      end

      def self.init(klass,name)
        Rails.logger.debug "Hummingbird #{self} for #{klass} #{name}"
      end

      def add(type=nil,point=0)
        raise NotImplementedError, "Implement #{self.class}#add method"
      end

      def value
        raise NotImplementedError, "Implement #{self.class}#value method"
      end
    end
  end
end

Dir[File.expand_path("../process/**/*.rb",__FILE__)].each do |f|
  require f
end
