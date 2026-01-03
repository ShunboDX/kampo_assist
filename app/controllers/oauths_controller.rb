class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def create
    auth = request.env["omniauth.auth"]
    unless auth
      return redirect_to new_user_session_path, alert: "Googleログインに失敗しました"
    end

    provider = auth["provider"]
    uid = auth["uid"]

    email = auth.dig("info", "email")
    name  = auth.dig("info", "name")

    email_verified =
      auth.dig("info", "email_verified") ||
      auth.dig("extra", "raw_info", "email_verified")

    # provider / uid が取れない場合は異常
    if provider.blank? || uid.blank?
      return redirect_to new_user_session_path, alert: "Googleログインに失敗しました"
    end

    # 1) provider+uid が既にあるなら、それを最優先
    if (authorization = Authorization.find_by(provider: provider, uid: uid))
      auto_login(authorization.user)
      return redirect_to root_path, notice: "Googleでログインしました"
    end

    # 2) provider+uid が無い場合、email_verified が true でないなら失敗
    unless email_verified && email.present?
      return redirect_to new_user_session_path, alert: "Googleログインに失敗しました"
    end

    # 3) email一致があれば既存Userに紐付け、無ければ新規作成
    user = nil

    ActiveRecord::Base.transaction do
      user = User.find_by(email: email) || User.create!(email: email)
      Authorization.create!(
        user: user,
        provider: provider,
        uid: uid,
        email: email,
        name: name
      )
    end

    auto_login(user)
    redirect_to root_path, notice: "Googleでログインしました"
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid => e
    # 競合やバリデーションエラー（例: 同時ログイン等）
    Rails.logger.warn("[OAuth] login DB error: #{e.class} #{e.message}")
    redirect_to new_user_session_path, alert: "Googleログインに失敗しました"
  rescue StandardError => e
    Rails.logger.error("[OAuth] login failed: #{e.class} #{e.message}")
    redirect_to new_user_session_path, alert: "Googleログインに失敗しました"
  end

  def failure
    redirect_to new_user_session_path, alert: "Googleログインに失敗しました"
  end
end
