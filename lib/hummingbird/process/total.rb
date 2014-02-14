module Hummingbird
  module Process
    class Total < Base
      def add(type=nil,point=0)
        hummingbird.object.send("#{hummingbird.name}=",hummingbird.object.send(hummingbird.name).to_i + point.to_i)
        hummingbird.object.save
      end

      def value
        hummingbird.object.send(hummingbird.name)
      end
    end
  end
end
