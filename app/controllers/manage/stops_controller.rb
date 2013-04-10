class Manage::StopsController < Manage::BaseManagementController

  before_filter :load_stop, except: [ :index ]

  def index
    @stops = Stop.order(:allowed_vehicles, :eid)
  end



  def edit
    gon.stop = @stop
  end


  def update
  end

  private


  def load_stop
    @stop = Stop.find(params[:id])
  end

end
