module Api
  module V1
    class BaseApiController < ActionController::Metal
      include ClassnameTagLogger
      include ActionController::Rendering
      include ActionController::Renderers::All
      include ActionController::MimeResponds
      include AbstractController::Callbacks # for *_filter

      append_view_path "#{Rails.root}/app/views"


      def test
        render json: { response: 'ok' }
      end


    end
  end
end
