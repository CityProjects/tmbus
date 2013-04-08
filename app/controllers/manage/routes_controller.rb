class Manage::RoutesController < Manage::BaseManagementController

  before_filter :load_route, except: [ :index ]

  def index
  end



  def edit
    gon.route = @route
  end


  def update
  end

  private


  def load_route
    @route = Route.find(params[:id])
  end

end
