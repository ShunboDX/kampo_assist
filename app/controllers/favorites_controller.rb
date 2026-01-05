class FavoritesController < ApplicationController
  before_action :require_login
  before_action :set_kampo

  def create
    begin
      current_user.favorites.create!(kampo: @kampo)
    rescue ActiveRecord::RecordNotUnique
      # 連打や競合が起きても落とさない（すでに登録済みならOK扱い）
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "favorite_kampo_#{@kampo.id}",
          partial: "kampos/favorite_button",
          locals: { kampo: @kampo, favorited: true }
        )
      end
      format.html { redirect_back fallback_location: kampo_path(@kampo), notice: "お気に入りに追加しました" }
    end
  end

  def destroy
    favorite = current_user.favorites.find_by(kampo: @kampo)
    favorite&.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "favorite_kampo_#{@kampo.id}",
          partial: "kampos/favorite_button",
          locals: { kampo: @kampo, favorited: false }
        )
      end
      format.html { redirect_back fallback_location: kampo_path(@kampo), notice: "お気に入りを解除しました" }
    end
  end

  private

  def set_kampo
    @kampo = Kampo.find(params[:kampo_id])
  end
end
