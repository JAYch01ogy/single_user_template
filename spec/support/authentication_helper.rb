def log_in(user)
  visit new_user_session_path
  fill_in('user_email', with: user.email)
  fill_in('user_password', with: user.password)
  click_button('Log in')
end

def request_log_in(user)
  post user_session_path, params: { user: { email: user.email, password: user.password } }
  follow_redirect!
end
