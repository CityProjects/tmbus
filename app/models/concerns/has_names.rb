module Concerns
  module HasNames
    extend ActiveSupport::Concern

    included do

      attr_accessible :name, :long_name

      validates :name, presence: true

    end





  end
end
