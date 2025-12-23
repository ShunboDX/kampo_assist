class StaticPagesController < ApplicationController
  # skip_before_action :require_login, only: %i[terms privacy how_to]

  def terms; end
  def privacy; end
  def how_to; end
end
