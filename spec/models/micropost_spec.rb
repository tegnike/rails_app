require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  describe "Micropostの有効性をテストする" do
    it "有効であること" do
      expect(@micropost).to be_valid
    end
  end

  describe "各カラムのバリデーションを確認する" do
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_length_of(:content).is_at_most(140) }
  end

  describe "仕様をテストする" do
    let!(:orange) { create(:orange) }
    let!(:cat_video) { create(:cat_video) }
    let!(:tau_manifesto) { create(:tau_manifesto) }
    let!(:most_recent) { create(:most_recent) }
    it "降順に表示されること" do
      expect(Micropost.first).to eq most_recent
    end
  end

end
