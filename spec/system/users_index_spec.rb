require "rails_helper"

RSpec.describe "UsersIndexTest", type: :system, js: true do
  describe "UserIndex画面をテストする" do
    context "adminユーザーでログインした場合" do
      let!(:michael) { create(:michael) } # adminユーザー
      before { create_list(:user, 30)
               visit login_path
               fill_in "Email", with: "michael@example.com"
               fill_in "Password", with: "password"
               click_button "Log in"
               visit users_path
      }
      it "ページネーションが正しく表示されていること" do
        expect(page).to have_css ".pagination"
        User.paginate(page: 1).each do |user|
          expect(page).to have_link "#{user.name}"
        end
      end
      it "削除ボタンが正しく表示されていること" do
        User.paginate(page: 1).each do |user|
          unless user == michael
            expect(page).to have_link "delete"
          end
        end
      end
    end

    context "非adminユーザーでログインした場合" do
      before { create(:archer) # 非adminユーザー
               create_list(:user, 30)
               visit login_path
               fill_in "Email", with: "duchess@example.gov"
               fill_in "Password", with: "password"
               click_button "Log in"
               visit users_path
      }
      it "削除ボタンが表示されないこと" do
        expect(page).not_to have_link "delete"
      end
    end
  end
end
