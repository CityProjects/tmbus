module Concerns
  module HasEid
    extend ActiveSupport::Concern

    included do

      attr_accessible :eid

    end





  end
end
