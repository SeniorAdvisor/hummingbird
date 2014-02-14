module Hummingbird
  module Process
    class Log < Base
      def add(type=nil,point=0)
        Hummingbird::Point.create(
          :owner_class => hummingbird.object.class.name,
          :owner_type => hummingbird.name.to_s,
          :owner_id => hummingbird.object.id,
          :type_id => type.try(:id).to_i,
          :point => point.to_i)
      end

      def self.init(klass,name)
        super(klass,name)
        ActiveRecord::Associations::Builder::HasMany.build(klass,"hummingbird_#{name.to_s.pluralize}", :conditions => ["owner_class = ? and owner_type = ?",klass.name,name.to_s], :class_name => "Hummingbird::Point", :foreign_key => "owner_id")
      end

      def value
        hummingbird.object.send("hummingbird_#{hummingbird.name.to_s.pluralize}")
      end
    end
  end
end
