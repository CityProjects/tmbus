module Concerns
  module HasNames
    extend ActiveSupport::Concern

    included do

      attr_accessible :name, :long_name


    end





  end
end
