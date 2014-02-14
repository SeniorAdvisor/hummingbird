module Hummingbird
  module Process
    class Badge < Base
      def self.init(klass,name)
        super(klass,name)
        ActiveRecord::Associations::Builder::HasMany.build(klass,"hummingbird_#{name}_badges", :conditions => ["owner_class = ? and owner_type = ?",klass.name,name.to_s], :class_name => "Hummingbird::Level", :foreign_key => "owner_id")
      end

      def value
        hummingbird.object.send("hummingbird_#{hummingbird.name}_badges")
      end

      def add(type=nil,point=0)
        log_badge
      end

      def log_badge
        current_value = hummingbird.object.send(hummingbird.name).to_i
        badge = Hummingbird::Badge.where("points <= #{current_value}").order("points ASC").last

        if badge && Hummingbird::Level.where("owner_id = ? and owner_class= ? and owner_type = ? and badge_id = ?",hummingbird.object.id, hummingbird.object.class.name, hummingbird.name.to_s, badge.id).empty?
          Hummingbird::Level.create(
              :owner_class => hummingbird.object.class.name,
              :owner_type => hummingbird.name.to_s,
              :owner_id => hummingbird.object.id,
              :badge_id => badge.id
          )
        end
      end
    end
  end
end
