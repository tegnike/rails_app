require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe "永続的セッションの仕様を確認する" do
    include SessionsHelper
    let!(:user) { create(:user, email: "user@example.com") }
    before {
      remember(user)
    }

    context "セッションがnilだった場合" do
      it "'current_user'は'user'と等しい" do
        expect(current_user).to eq user
        expect(logged_in?).to be_truthy
      end
    end
    context "'Remember digest'が正しい値でない場合" do
      before {
        user.update_attribute(:remember_digest, User.digest(User.new_token))
      }
      it "'current_user'はnilである" do
        expect(current_user).to eq nil
      end
    end
  end
end
