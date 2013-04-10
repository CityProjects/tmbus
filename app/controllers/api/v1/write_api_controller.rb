module Api
  module V1
    class WriteApiController < Api::V1::BaseApiController


      def route_update

        render json: {}
      end


      private


      def load_route
        @route = Route.find(params[:id])
      end



    end
  end
end
