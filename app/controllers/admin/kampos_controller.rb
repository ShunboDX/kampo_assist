module Admin
  class KamposController < BaseController
    def index
      @q = params[:q].to_s.strip
      @kampos = Kampo.order(:id)
      return if @q.blank?

      escaped = ActiveRecord::Base.sanitize_sql_like(@q)

      @kampos = @kampos.where(
        "name LIKE :q OR kana_name LIKE :q",
        q: "%#{escaped}%"
      )
    end

    def edit
      @kampo = Kampo.find(params[:id])
    end

    def update
      @kampo = Kampo.find(params[:id])

      if @kampo.update(kampo_params)
        redirect_to admin_kampos_path, notice: "更新しました"
      else
        flash.now[:alert] = "更新に失敗しました"
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def kampo_params
      params.require(:kampo).permit(:name, :kana_name, :note, :detail)
    end
  end
end
