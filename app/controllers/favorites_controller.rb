class FavoritesController < ApplicationController
  before_action :require_login
  before_action :set_kampo

  def create
    current_user.favorites.create!(kampo: @kampo)
    redirect_back fallback_location: kampo_path(@kampo), notice: "お気に入りに追加しました"
  end

  def destroy
    favorite = current_user.favorites.find_by!(kampo: @kampo)
    favorite.destroy!
    redirect_back fallback_location: kampo_path(@kampo), notice: "お気に入りを解除しました"
  end

  private

  def set_kampo
    @kampo = Kampo.find(params[:kampo_id])
  end
end
