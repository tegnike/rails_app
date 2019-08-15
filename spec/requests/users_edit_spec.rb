# frozen_string_literal: true

require "rails_helper"

RSpec.describe "UsersEditTest", type: :request do
  describe "ユーザー編集をテストする" do
    let!(:user) { create(:user, name: "Example", email: "user@example.com") }
    context "無効な情報で編集を試みた場合" do
      before {
        log_in_as(user)
        get edit_user_path(user)
        put user_path(user), params: { user: { name:  "",
                                                  email: "foo@invalid",
                                                  password:              "foo",
                                                  password_confirmation: "bar" } }
      }
      it "edit_user_pathにレンダーされること" do
        expect(response).to render_template "users/edit"
      end
      it "フラッシュメッセージが表示されること" do
        expect(response.body).to include "alert-danger"
      end
    end

    context "有効な情報で編集を試みた場合" do
      before {
        log_in_as(user)
        get edit_user_path(user)
        put user_path(user), params: { user: { name:  "Example2",
                                                  email: "user2@example.com",
                                                  password:              "",
                                                  password_confirmation: "" } }
      }
      it "user_pathにリダイレクトされ、ユーザ名が更新されること" do
        expect(response).to redirect_to user_path(user)
        user.reload
        expect(user.name).to eq("Example2")
      end
    end

    context "ログインせずに編集画面へアクセスした場合" do
      before { get edit_user_path(user) }
      it "ログイン画面にリダイレクトされること" do
        expect(response).to redirect_to login_url
      end
    end

    context "ログインせずに編集情報を送信した場合" do
      before {
        put user_path(user), params: { user: { name: "Example2",
                                                  email: user.email } }
      }
      it "ログイン画面にリダイレクトされ、ユーザ名が更新されないこと" do
        expect(response).to redirect_to login_url
        user.reload
        expect(user.name).not_to eq("Example2")
      end
    end
  end

  describe "フレンドリーフォワーディングをテストする" do
    let!(:user) { create(:user, name: "Example", email: "user@example.com") }
    context "ログインせずに編集画面へアクセスした場合" do
      before { get edit_user_path(user) }
      it "ログイン後に編集画面へリダイレクトされること" do
        log_in_as(user)
        expect(response).to redirect_to edit_user_path(user)
      end
      it "再ログイン後にユーザ画面へリダイレクトされること" do
        log_in_as(user)
        log_out
        log_in_as(user)
        expect(response).to redirect_to user_path(user)
      end
    end
  end
end
