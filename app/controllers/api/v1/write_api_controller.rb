module Api
  module V1
    class WriteApiController < Api::V1::BaseApiController


      def route_update

        render nothing: true
      end


      private


      def load_route
        @route = Route.find(params[:id])
      end



    end
  end
end
