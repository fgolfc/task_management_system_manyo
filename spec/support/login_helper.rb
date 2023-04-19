module LoginHelper
  def sign_in_as(user)
    visit new_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

  def sign_out
    click_link "ログアウト"
  end
end