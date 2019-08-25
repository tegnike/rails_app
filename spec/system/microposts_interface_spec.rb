require "rails_helper"

RSpec.describe "MicropostsInterfaceTest", type: :system, js: true do
  describe "micropostのUIをテストする" do
    let(:michael) { create(:michael) }
    let(:archer) { create(:archer) }
    before {
      create_list(:micropost, 30, user_id: michael.id)
      create_list(:micropost, 30, user_id: archer.id)

      visit login_path
      fill_in "Email", with: "michael@example.com" # michaelでログイン
      fill_in "Password", with: "password"
      click_button "Log in"
      visit root_path
    }
    context "無効なmicropostを送信した場合" do
      before {
        fill_in_rich_text_area "micropost_content", with: ""
        click_button "Post"
        sleep 1
      }
      it "投稿できないこと" do
        expect(page).to have_css "div#error_explanation"
      end
    end
    context "有効なmicropostを送信した場合" do
      content = "This micropost really ties the room together"
      before {
        fill_in_rich_text_area "micropost_content", with: content
        attach_file "micropost_picture", "#{Rails.root}/spec/factories/rails.png"
        click_button "Post"
      }
      it "投稿できること" do
        expect(current_path).to eq root_path
        expect(page).to have_content content
        expect(page).to have_css ".picture"
      end
    end
    context "削除リンクを押した場合" do
      subject {
        first("ol li").click_link "delete"
        page.driver.browser.switch_to.alert.accept
        find ".alert", text: "Micropost deleted"
      }
      it "投稿を削除できること" do
        expect { subject }.to change { Micropost.count }.by(-1)
      end
    end
    context "違うユーザー（archer）のプロフィールにアクセスした場合" do
      before { visit user_path(archer) }
      it "削除リンクが表示されていないこと" do
        expect(page).not_to have_link "delete"
      end
    end
  end
  describe "サイドバーでmicropostの投稿数をテストする" do
    let!(:user) { create(:user, email: "user@example.com") }
    before {
      visit login_path
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password"
      click_button "Log in"
      visit root_path
    }
    context "micropostを未投稿の場合" do
      it "'0 microposts'と表示されること" do
        expect(page).to have_content "0 microposts"
      end
    end
    context "micropostを1度投稿した場合" do
      before {
        fill_in_rich_text_area "micropost_content", with: "This micropost really ties the room together"
        click_button "Post"
      }
      it "'1 micropost'と表示されること" do
        expect(page).to have_content "1 micropost"
      end
    end
  end
end
