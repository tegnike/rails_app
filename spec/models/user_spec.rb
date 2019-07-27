require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "Userの有効性を確認する" do
    it "有効なファクトリを持つこと" do
      expect(user).to be_valid
    end
    # Shoulda Matchers を使用
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe "メールアドレスの有効性を確認する" do
    it "有効なメールアドレスの場合、有効であること" do
      valid_addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end
    it "無効なメールアドレスの場合、有効でないこと" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to_not be_valid
      end
    end
  end

  it "emailは大文字小文字を区別せず、一意であること" do
    create(:user, email: "user@example.com")
    user = build(:user, email: "USER@example.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  describe "パスワード確認が一致すること" do
    it "一致する場合、有効であること" do
      user = build(:user, password: "password", password_confirmation: "password")
      expect(user).to be_valid
    end
    it "一致しない場合、有効でないこと" do
      user = build(:user, password: "password", password_confirmation: "different")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end
end
