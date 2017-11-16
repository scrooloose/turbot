class StaticPagesController < ApplicationController
  def show
    if logged_in?
      return redirect_to dashboards_path
    end

    render params[:id]
  end
end
