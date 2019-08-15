# frozen_string_literal: true

require "rails_helper"

RSpec.describe "UsersSignup", type: :system, js: true do
  describe "サインアップを確認する" do
    context "無効なユーザでサインアップした場合" do
      before {
        visit signup_path
        fill_in "Name", with: ""
        fill_in "Email", with: "user@invalid"
        fill_in "Password", with: "foo"
        fill_in "Confirmation", with: "bar"
        click_on "Create my account"
      }
      it "ユーザーが登録されず、'users/new'に遷移し、失敗メッセージが表示される" do
        expect(User.where(email: "user@invalid").first).not_to be
        expect(current_path).to eq signup_path
        expect(page).to have_css "#error_explanation"
      end
    end

    context "有効なユーザでサインアップした場合" do
      before {
        visit signup_path
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "password"
        fill_in "Confirmation", with: "password"
        click_on "Create my account"
      }
      it "root_pathに遷移し、メッセージが表示される" do
        expect(current_path).to eq root_path
        expect(page).to have_css ".alert-info"
      end
    end
  end
end
