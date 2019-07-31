require 'rails_helper'

RSpec.feature "UsersLoginTest", type: :feature do
  describe "ログインを確認する" do
    let!(:user) { create(:user, email: "user@example.com") }

    context "無効な情報でログインを試みた場合" do
      before {
        visit login_path
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: ""
        click_button 'Log in' }
      it "login_pathにレンダーされること" do
        expect(current_path).to eq login_path
      end
      it "フラッシュメッセージが表示されること" do
        expect(page).to have_css '.alert-danger'
      end
      it "root_pathに遷移後フラッシュメッセージが表示されないこと" do
        visit root_path
        expect(page).to have_no_css '.alert-danger'
      end
    end

    context "有効な情報でログインを試みた場合" do
      before {
        visit login_path
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "password"
        click_button 'Log in'
      }
      it "user_pathにリダイレクトされること" do
        expect(current_path).to eq user_path(user.id)
      end
      it "ヘッダーのリンク表示が変わること" do
        expect(page).to have_no_link 'Log in'
        expect(page).to have_link 'Log out'
        expect(page).to have_link 'Profile'
      end
      it "ログアウト後、ヘッダーのリンク表示が変わること" do
        click_on 'Log out'
        expect(page).to have_link 'Log in'
        expect(page).to have_no_link 'Log out'
        expect(page).to have_no_link 'Profile'
      end
    end

    context "ダイジェストが存在しない場合" do
      it { expect(user.authenticated?('')).to be_falsey }
    end
  end
end
