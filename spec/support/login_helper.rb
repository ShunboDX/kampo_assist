# spec/support/login_helper.rb
module LoginHelper
  def login_as(user, password: "password")
    post user_session_path,
         params: { email: user.email, password: password }
  end
end
