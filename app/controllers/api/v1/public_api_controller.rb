module Api
  module V1
    class PublicApiController < Api::V1::BaseApiController

      before_filter :load_route, except: [ :index ]

      def index
        render json: [{ 'route1' => 'data1' }, { 'route2' => 'data2' }]
      end


      def show
        render 'api/v1/public/route'
      end



      private


      def load_route
        @route = Route.find(params[:id])
      end



    end
  end
end
