class SearchSessionsController < ApplicationController
  before_action :require_login

  def index
    @search_sessions = current_user.search_sessions.order(created_at: :desc)
  end
end
