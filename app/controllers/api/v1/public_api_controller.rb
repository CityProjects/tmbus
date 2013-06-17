module Api
  module V1
    class PublicApiController < Api::V1::BaseApiController

      before_filter :load_route, only: [ :route_show ]



      def stops
        @stops = Stop.all
        render 'api/v1/public/stops'
      end


      def routes
        render json: []
      end


      def route_show
        render 'api/v1/public/route'
      end



      private


      def load_route
        @route = Route.find(params[:id])
      end



    end
  end
end
