require 'rails_helper'

RSpec.feature "UsersLoginTest", type: :request do
  describe "ログインを確認する" do
    let!(:user) { create(:user, email: "user@example.com") }

    def is_logged_in?
      !session[:user_id].nil?
    end

    context "有効な情報でログインを試みた場合" do
      before {
        post login_path, params: { session: { email: "user@example.com",
                                            password: "password" } }
        redirect_to user
        follow_redirect!
      }
      it "2つ目のウインドウでログアウトしてもエラーにならないこと" do
        delete logout_path
        delete logout_path
        follow_redirect!
        expect(response).to render_template('static_pages/home')
        expect(is_logged_in?).to be_falsey
      end
    end
  end

  describe "リメンバーミー機能を確認する" do
    let!(:user) { create(:user, email: "user@example.com") }

    # テストユーザーとしてログインする
    def log_in_as(user, password: 'password', remember_me: '1')
      post login_path, params: { session: { email: user.email,
                                            password: password,
                                            remember_me: remember_me } }
    end

    context "リメンバーミーにチェックした場合" do
      before {
        log_in_as(user, remember_me: '1')
      }
      it "クッキーがnilでない" do
        expect(cookies['remember_token']).to be_truthy
      end
    end
    context "リメンバーミーにチェックしなかった場合" do
      before {
        log_in_as(user, remember_me: '0')
      }
      it "クッキーがnilである" do
        expect(cookies['remember_token']).to be_falsey
      end
    end
  end
end
