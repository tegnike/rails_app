require "rails_helper"

RSpec.describe "UsersSignup", type: :request do
  describe "アクティブ機能付きのサインアップを確認する" do
    before {
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
      @user = assigns(:user)
    }
    context "有効化していない状態でログインを試した場合" do
      before { log_in_as(@user) }
      it "ログインできないこと" do
        expect(is_logged_in?).to be_falsey
      end
    end
    context "有効化トークンが不正な場合" do
      before { get edit_account_activation_path("invalid token", email: @user.email) }
      it "ログインできないこと" do
        expect(is_logged_in?).to be_falsey
      end
    end
    context "トークンは正しいがメールアドレスが無効な場合" do
      before { get edit_account_activation_path(@user.activation_token, email: "wrong") }
      it "ログインできないこと" do
        expect(is_logged_in?).to be_falsey
      end
    end
    context "有効化トークンが正しい場合" do
      before { get edit_account_activation_path(@user.activation_token, email: @user.email) }
      it "ログインできること" do
        expect(is_logged_in?).to be_truthy
        expect(response).to redirect_to user_path(@user)
      end
    end
  end
  describe "ActionMailer::Base.deliveriesを確認する" do
    before {
      ActionMailer::Base.deliveries.clear
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    }
    it "配信されたメッセージが1つであること" do
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end
  end
end
