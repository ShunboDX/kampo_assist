class FavoritesController < ApplicationController
  before_action :require_login
  before_action :set_kampo, only: %i[create destroy]

  def index
    @favorites = current_user.favorites.includes(:kampo).order(created_at: :desc)
    @kampos = @favorites.map(&:kampo)
  end

  def create
    current_user.favorites.find_or_create_by!(kampo: @kampo)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "favorite_kampo_#{@kampo.id}",
          partial: "kampos/favorite_button",
          locals: { kampo: @kampo, favorited: true }
        )
      end
      format.html do
        redirect_back fallback_location: kampo_path(@kampo), notice: "お気に入りに追加しました"
      end
    end
  end

  def destroy
    current_user.favorites.find_by(kampo: @kampo)&.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "favorite_kampo_#{@kampo.id}",
          partial: "kampos/favorite_button",
          locals: { kampo: @kampo, favorited: false }
        )
      end
      format.html do
        redirect_back fallback_location: kampo_path(@kampo), notice: "お気に入りを解除しました"
      end
    end
  end

  private

  def set_kampo
    @kampo = Kampo.find(params[:kampo_id])
  end
end
