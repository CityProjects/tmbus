module Api
  module V1
    class RoutesApiController < Api::V1::BaseApiController

      def index
        render json: [{ 'route1' => 'data1' }, { 'route2' => 'data2' }]
      end


      def show
        render json: { 'route1' => 'data1' }
      end



    end
  end
end
