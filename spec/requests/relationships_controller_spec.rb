require "rails_helper"

RSpec.describe RelationshipsController, type: :request do
  describe "PUT #create" do
    context "ログインせずにフォローを実行した場合" do
      subject { post relationships_path }
      it "フォロー数は変化せず、ログイン画面にリダイレクトされること" do
        expect { subject }.to change { Relationship.count }.by(0)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:michael) { create(:michael) }
    context "ログインせずにアンフォローを実行した場合" do
      subject { delete relationship_path(michael) }
      it "ユーザーは変化せず、ログイン画面にリダイレクトされること" do
        expect { subject }.to change { Relationship.count }.by(0)
        expect(response).to redirect_to login_url
      end
    end
  end
end
