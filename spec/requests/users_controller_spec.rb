# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersController, type: :request do
  describe "GET #index" do
    context "ログインしていない場合"
    it "ログイン画面にリダイレクトされること" do
      get users_path
      expect(response).to redirect_to login_url
    end
  end

  describe "GET #new" do
    it "リクエストが成功すること" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    let(:michael) { create(:michael) }
    let(:archer) { create(:archer) }
    before { log_in_as(michael) }
    context "自分の編集画面にアクセスした場合" do
      before { get edit_user_path(michael) }
      it "リクエストが成功すること" do
        expect(response).to have_http_status(:success)
      end
    end
    context "他人の編集画面にアクセスした場合" do
      before { get edit_user_path(archer) }
      it "ルート画面にリダイレクトされること" do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "PATCH #update" do
    let(:michael) { create(:michael) }
    let(:archer) { create(:archer) }
    before { log_in_as(michael) }
    context "自分の編集情報を正しく送信した場合" do
      before {
        put user_path(michael), params: { user: { name: "michael2",
                                                  email: michael.email } }
      }
      it "リクエストが成功すること" do
        expect(response.status).to eq 302
      end
      it "ユーザー名が更新されること" do
        expect(User.find(michael.id).name).to eq("michael2")
      end
    end
    context "他人の編集情報を送信した場合" do
      before {
        put user_path(archer), params: { user: { name: archer.name,
                                                  email: archer.email } }
      }
      it "ルート画面にリダイレクトされること" do
        expect(response).to redirect_to root_url
      end
    end
    context "adminをtrueに編集して情報を送信した場合" do
      let!(:user) { create(:user, email: "user@example.com") }
      before {
        put user_path(user), params: { user: { name: user.name,
                                                  email: user.email,
                                                  admin: true } }
      }
      it "adminがtrueになっていないこと" do
        expect(user.admin?).not_to be_truthy
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:michael) { create(:michael) } # adminユーザー
    let!(:archer) { create(:archer) }
    context "ログインせずに削除を実行した場合" do
      subject { delete user_path(michael) }
      it "ユーザーは変化せず、ログイン画面にリダイレクトされること" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to redirect_to login_url
      end
    end
    context "adminユーザーでない場合" do
      before {
        log_in_as(archer)
        delete user_path(michael)
      }
      it "ユーザー数は変化せず、ルート画面にリダイレクトされること" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to redirect_to root_url
      end
    end
    context "adminユーザーの場合" do
      before { log_in_as(michael) }
      subject { delete user_path(archer) }
      it "ユーザーが1減ること" do
        expect { subject }.to change { User.count }.by(-1)
      end
    end
  end
end
