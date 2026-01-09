# spec/support/system_login_helper.rb
module SystemLoginHelper
  def system_login_as(user, password: "password")
    # rack_test driver 前提（JSなしのsystem specなら通常これ）
    page.driver.submit :post, user_session_path, {
      email: user.email,
      password: password
    }
  end
end
