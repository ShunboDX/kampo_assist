module Admin
  class KamposController < BaseController
    def index
      @kampos = Kampo.order(:id)
    end
  end
end
