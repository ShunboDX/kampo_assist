class KamposController < ApplicationController
  def show
    @kampo = Kampo.find(params[:id])
  end
end
