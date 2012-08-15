module Extras::Finders

  def self.included(klass)
    klass.extend(ClassMethods)
  end




  module ClassMethods

    def find_by_id(id)
       where(_id: id).first
    end
  end

end