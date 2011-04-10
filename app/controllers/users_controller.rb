class UsersController < ApplicationController

  def index
    if params[:q].present?
      @users = User.select([:id, :name]).where("name like ?", "%#{params[:q]}%")
    else
      @users = User.all
    end
    respond_to do |format|
      format.json { render :json => @users.map(&:attributes) }
    end
  end

end
