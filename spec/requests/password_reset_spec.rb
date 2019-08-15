require 'rails_helper'

RSpec.describe "PasswordReset", type: :request do

  describe "パスワード再設定用のメール送信をテストする" do
    let(:user) { create(:michael)}
    context "メールアドレスが無効の場合" do
      before { post password_resets_path, params: { password_reset: { email: "" } } }
      it "エラーメッセージが表示されること" do
        expect(response.body).to include 'alert-danger'
      end
    end
    context "メールアドレスが有効な場合" do
      before {
        ActionMailer::Base.deliveries.clear
        post password_resets_path, params: { password_reset: { email: user.email } }
      }
      it "reset_digestが更新されていること" do
        expect(user.reset_digest).not_to eq(user.reload.reset_digest)
      end
      it "配信されたメッセージが1つであること" do
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
      it "root_urlにリダイレクトされること" do
        expect(response.body).not_to include 'alert-danger'
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "メールリンクをテストする" do
    let(:user) { create(:michael)}
    before {
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = assigns(:user)
    }
    context "メールアドレスが無効の場合" do
      before { get edit_password_reset_path(@user.reset_token, email: "") }
      it "root_urlにリダイレクトされること" do
        expect(response).to redirect_to root_url
      end
    end
    context "無効なユーザーの場合" do
      before {
        @user.toggle!(:activated)
        get edit_password_reset_path(@user.reset_token, email: @user.email)
      }
      it "root_urlにリダイレクトされること" do
        expect(response).to redirect_to root_url
      end
    end
    context "メールアドレスが有効で、トークンが無効な場合" do
      before { get edit_password_reset_path('wrong token', email: @user.email) }
      it "root_urlにリダイレクトされること" do
        expect(response).to redirect_to root_url
      end
    end
    context "メールアドレスもトークンも有効な場合" do
      before { get edit_password_reset_path(@user.reset_token, email: @user.email) }
      it "リクエストが成功すること" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "パスワード再設定フォームをテストする" do
    let(:user) { create(:michael)}
    before {
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = assigns(:user)
    }
    context "無効なパスワードの場合" do
      before {
        patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
      }
      it "エラーメッセージが表示されること" do
        expect(response.body).to include 'error_explanation'
      end
    end
    context "パスワードが空の場合" do
      before {
        patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
      }
      it "エラーメッセージが表示されること" do
        expect(response.body).to include 'error_explanation'
      end
    end
    context "パスワードが有効な場合" do
      before {
        patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
      }
      it "ログインすること" do
        expect(is_logged_in?).to be_truthy
        expect(response).to redirect_to @user
      end
    end
  end

  describe "パスワード再設定の期限切れをテストする" do
    let(:user) { create(:michael)}
    before {
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = assigns(:user)
    }
    context "発行3時間後に再設定を試みた場合" do
      before {
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
      }
      it "new_password_reset_pathにリダイレクトされること" do
        expect(response).to redirect_to new_password_reset_path
      end
    end
    context "発行1時間後に再設定を試みた場合" do
      before {
        @user.update_attribute(:reset_sent_at, 1.hours.ago)
        patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
      }
      it "ログインすること" do
        expect(is_logged_in?).to be_truthy
        expect(response).to redirect_to @user
      end
    end
  end
end
