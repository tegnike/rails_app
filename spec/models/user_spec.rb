# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

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
end
