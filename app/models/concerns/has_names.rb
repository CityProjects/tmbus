module Concerns
  module HasNames
    extend ActiveSupport::Concern

    included do

      attr_accessible :name, :long_name
      attr_accessible :alternate_names



    end





  end
end
