class KamposController < ApplicationController
  def show
    @kampo = Kampo.find(params[:id])
    @favorited = logged_in? && current_user.favorites.exists?(kampo_id: @kampo.id)
  end
end
