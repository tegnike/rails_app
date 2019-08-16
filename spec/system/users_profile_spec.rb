require 'rails_helper'

RSpec.describe "UsersProfile", type: :system, js: true do
  describe "Userプロフィール画面をテストする" do
    let(:user) { create(:user) }
    before {
      create_list(:micropost, 31, user_id: user.id)
      visit user_path(user)
    }
    it "ユーザー情報、Title、CSSが正しく表示されていること" do
      expect(page).to have_title full_title(user.name)
      expect(page).to have_selector 'h1', text: user.name
      expect(page).to have_css 'h1>img.gravatar'
      expect(page).to have_content user.microposts.count.to_s
      expect(page).to have_css 'div.pagination'
    end
    it "Micropostのページネーションが正しく表示されていること" do
      user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_content "#{micropost.content}"
      end
    end
  end
end
