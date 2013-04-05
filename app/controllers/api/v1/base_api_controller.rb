module Api
  module V1
    class BaseApiController < ActionController::Base
      layout false

      respond_to :json

      def test
        render json: { response: 'ok' }
      end


    end
  end
end
