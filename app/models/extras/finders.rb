module Extras::Finders
  extend ActiveSupport::Concern



  module ClassMethods

    def find_by_id(id)
       where(_id: id).first
    end
  end

end
