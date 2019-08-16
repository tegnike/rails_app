require "rails_helper"

RSpec.describe "UserPages", type: :system, js: true do
  describe "signup page" do
    before do
      visit signup_path
    end

    # 新規登録ページに"Sign up"と表示されていること
    it "should have the content 'Sign up'" do
      expect(page).to have_content "Sign up"
    end

    # タイトルが正しく表示されていること
    it "should have the right title" do
      expect(page).to have_title full_title("Sign up")
    end
  end
end
