require "rails_helper"

RSpec.describe "Following", type: :system, js: true do
  describe "following/followerページをテストする" do
    let(:user1) { create(:user, email: "user@example.com") }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let(:user4) { create(:user) }
    before {
      user1.following << user2
      user1.following << user3
      user2.following << user1
      user4.following << user1

      visit login_path # user1でログイン
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password"
      click_button "Log in"
    }
    context "followingページへアクセスした場合" do
      before { visit following_user_path(user1) }
      it "following情報が正しく表示されていること" do
        expect(user1.following).not_to be_empty
        expect(page).to have_content user1.following.count.to_s
        user1.following.each do |user|
          expect(page).to have_link "#{user.name}"
        end
      end
    end
    context "followersページへアクセスした場合" do
      before { visit followers_user_path(user1) }
      it "followers情報が正しく表示されていること" do
        expect(user1.followers).not_to be_empty
        expect(page).to have_content user1.followers.count.to_s
        user1.followers.each do |user|
          expect(page).to have_link "#{user.name}"
        end
      end
    end
    context "他ユーザページへアクセスした場合" do
      before { visit user_path(user4) }
      it "follow/unfollowボタンが正しく動作すること" do
        expect(user1.following).not_to include(user4)
        click_button "Follow"
        sleep 1
        user1.reload
        expect(user1.following).to include(user4)
        click_button "Unfollow"
        sleep 1
        user1.reload
        expect(user1.following).not_to include(user4)
      end
    end
  end
end
