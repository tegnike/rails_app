require 'rails_helper'

RSpec.describe MicropostsController, type: :request do

  describe "POST #create" do
    context "ログインせずmicropostを投稿を試みた場合" do
      subject { post microposts_path, params: { micropost: { content: "Lorem ipsum" } } }
      it "投稿できずログイン画面にリダイレクトされること" do
        expect{ subject }.to change{ Micropost.count }.by(0)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "DELETE #destroy" do
    context "ログインせずmicropostの削除を試みた場合" do
      let!(:micropost) { create(:micropost) }
      subject { delete micropost_path(micropost) }
      it "削除できずログイン画面にリダイレクトされること" do
        expect{ subject }.to change{ Micropost.count }.by(0)
        expect(response).to redirect_to login_url
      end
    end

    context "ログイン時、他人のmicropostの削除を試みた場合" do
      let(:michael) { create(:michael) }
      let(:archer) { create(:archer) }
      let!(:micropost) { create(:micropost, user_id: archer.id) }
      before {
        log_in_as(michael)
      }
      subject { delete micropost_path(micropost) }
      it "削除できずホーム画面にリダイレクトされること" do
        expect{ subject }.to change{ Micropost.count }.by(0)
        expect(response).to redirect_to root_url
      end
    end
  end

end
