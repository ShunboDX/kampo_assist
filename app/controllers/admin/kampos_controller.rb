module Admin
  class KamposController < BaseController
    def index
      @kampos = Kampo.order(:id)
    end

    def edit
      @kampo = Kampo.find(params[:id])
    end
  end
end
