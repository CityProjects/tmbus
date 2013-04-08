module Concerns
  module HasExternalRefs
    extend ActiveSupport::Concern

    included do

      attr_accessible :eid
      attr_accessible :ename


      validates :eid, presence: true, uniqueness: true

    end





  end
end
