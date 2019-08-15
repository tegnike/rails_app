# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionsController, type: :request do
  describe "GET #new" do
    it "http通信に成功すること" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end
end
