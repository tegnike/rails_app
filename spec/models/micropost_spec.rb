require "rails_helper"

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
    let!(:orange) { create(:micropost, content: "I just ate an orange!", created_at: 10.minutes.ago) }
    let!(:tau_manifesto) { create(:micropost, content: "Check out the @tauday site by @mhartl: http://tauday.com", created_at: 3.years.ago) }
    let!(:cat_video) { create(:micropost, content: "Sad cats are sad: http://youtu.be/PKffm2uI4dk", created_at: 2.hours.ago) }
    let!(:most_recent) { create(:micropost, content: "Writing a short test", created_at: Time.zone.now) }
    it "降順に表示されること" do
      expect(Micropost.first).to eq most_recent
    end
  end
end
