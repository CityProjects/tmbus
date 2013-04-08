module Manage
  class BaseManagementController < ApplicationController

    layout 'manage_layout'


    def index
      render 'manage/index'
    end


  end
end
