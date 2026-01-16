module Admin
  class BaseController < ApplicationController
    before_action :require_admin!

    private

    def require_admin!
      return if current_user&.admin_user? # PR2で追加したラッパーを使う

      head :forbidden
    end
  end
end
git commit -m "feat: add admin namespace"