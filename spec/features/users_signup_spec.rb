require 'rails_helper'

RSpec.feature "UsersSignup", type: :feature do
  describe "サインアップを確認する" do
    context "無効なユーザでサインアップした場合" do
      subject {
        visit signup_path
        fill_in "Name", with: ""
        fill_in "Email", with: "user@invalid"
        fill_in "Password", with: "foo"
        fill_in "Confirmation", with: "bar"
        click_on 'Create my account' }
      it "全User数に変化がないこと" do
        expect{ subject }.to change{ User.count }.by(0)
      end
      it "'users/new'に遷移すること" do
        subject
        expect(current_path).to eq signup_path
      end
      it "エラーメッセージが表示されること" do
        subject
        expect(page).to have_css '#error_explanation'
      end
    end

    context "有効なユーザでサインアップした場合" do
      subject {
        visit signup_path
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "password"
        fill_in "Confirmation", with: "password"
        click_on 'Create my account' }
      it "全User数が1増加すること" do
        expect{ subject }.to change{ User.count }.by(1)
      end
      it "'users/show'に遷移すること" do
        subject
        user_id = User.find_by(name: "Example User").id
        expect(current_path).to eq user_path(user_id)
      end
      it "フラッシュメッセージが表示されること" do
        subject
        expect(page).to have_css '.alert-success'
      end
    end
  end


end
