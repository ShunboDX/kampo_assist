module Admin
  class KamposController < BaseController
    def index
      @kampos = Kampo.order(:id)
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
