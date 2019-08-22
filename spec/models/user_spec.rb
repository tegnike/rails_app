require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  describe "Userの有効性を確認する" do
    it "有効なファクトリを持つこと" do
      expect(user).to be_valid
    end
  end

  describe "Userの各カラムの有効性を確認する" do
    # Shoulda Matchers を使用
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe "メールアドレスの有効性を確認する" do
    context "有効なメールアドレスの場合" do
      valid_addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      it "有効であること" do
        valid_addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end
    context "無効なメールアドレスの場合" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com]
      it "有効でないこと" do
        invalid_addresses.each do |invalid_address|
          user.email = invalid_address
          expect(user).to_not be_valid
        end
      end
    end
  end

  describe "emailは大文字小文字を区別せず一意であること" do
    context "大文字小文字は異なるが同一のemailが存在する場合" do
      before do
        create(:user, email: "user@example.com")
      end
      let(:user) { build(:user, email: "USER@example.com") }
      it "エラーメッセージが表示されること" do
        user.valid?
        expect(user.errors[:email]).to include("has already been taken")
      end
    end
  end

  describe "パスワード確認が一致すること" do
    context "一致する場合" do
      let(:user) { build(:user, password: "password", password_confirmation: "password") }
      it "有効であること" do
        expect(user).to be_valid
      end
    end
    context "一致しない場合" do
      let(:user) { build(:user, password: "password", password_confirmation: "different") }
      it "有効でないこと" do
        user.valid?
        expect(user.errors[:password_confirmation]).to include("doesn't match Password")
      end
    end
  end

  describe "ユーザー削除時の仕様をテストする" do
    before {
      user.microposts.create!(content: "Lorem ipsum")
      user.destroy
    }
    it "関連するマイクロソフトも削除されること" do
      expect(Micropost.where(user: user)).to be_empty
    end
  end

  describe "followとunfollowをテストする" do
    let(:michael) { create(:michael) }
    let(:archer) { create(:archer) }
    subject(:follow) { michael.follow(archer) }
    subject(:unfollow) { michael.unfollow(archer) }
    it "フォローメソッドが正しく機能していること" do
      expect(michael.following?(archer)).to be_falsey
      follow
      expect(michael.following?(archer)).to be_truthy
      expect(archer.followers.include?(michael)).to be_truthy
      unfollow
      expect(michael.following?(archer)).to be_falsey
    end
  end

  describe "ステータスをテストする" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    before {
      create(:micropost, user_id: user1.id)
      create(:micropost, user_id: user2.id)
      create(:micropost, user_id: user3.id)
      create(:relationship, follower_id: user1.id, followed_id: user2.id) # user1がuser2をフォロー
    }
    it "フォローしているユーザの投稿がfeedにあること" do
      user2.microposts.each do |post_following|
        expect(user1.feed.include?(post_following)).to be_truthy
      end
    end
    it "自分自身の投稿がfeedにあること" do
      user1.microposts.each do |post_self|
        expect(user1.feed.include?(post_self)).to be_truthy
      end
    end
    it "フォローしていないユーザの投稿がfeedにないこと" do
      user3.microposts.each do |post_unfollowed|
        expect(user1.feed.include?(post_unfollowed)).to be_falsey
      end
    end
  end
end
