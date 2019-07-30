require 'rails_helper'

RSpec.feature "UsersSignup", type: :feature do
  describe "サインアップを確認する" do
    context "無効なユーザでサインアップした場合" do
      before {
        visit signup_path
        fill_in "Name", with: ""
        fill_in "Email", with: "user@invalid"
        fill_in "Password", with: "foo"
        fill_in "Confirmation", with: "bar"
        click_on 'Create my account'
      }
      it "ユーザーが登録されず、'users/new'に遷移し、失敗メッセージが表示される" do
        expect(User.where(email: "user@invalid").first).not_to be
        expect(current_path).to eq signup_path
        expect(page).to have_css '#error_explanation'
      end
    end

    context "有効なユーザでサインアップした場合" do
      before {
        visit signup_path
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "password"
        fill_in "Confirmation", with: "password"
        click_on 'Create my account'
      }

      it "ユーザーが登録され、'users/show'に遷移し、成功メッセージが表示される" do
        user = User.find_by(name: "Example User")
        expect(user).to be
        expect(current_path).to eq user_path(user)
        expect(page).to have_css '.alert-success'
      end
    end
  end


end
