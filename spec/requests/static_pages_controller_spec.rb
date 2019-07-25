require 'rails_helper'

describe StaticPagesController, type: :request do

  before(:all) {
    @base_title = "Ruby on Rails Tutorial Sample App"
  }

  describe "GET static pages" do
    it "home page returns http success" do
      get static_pages_home_path
      expect(response.status).to eq 200
      expect(response.body).to include("Home | #{@base_title}")
    end

    it "help page returns http success" do
      get static_pages_help_path
      expect(response.status).to eq 200
      expect(response.body).to include "Help | #{@base_title}"
    end

    it "about page returns http success" do
      get static_pages_about_path
      expect(response.status).to eq 200
      expect(response.body).to include "About | #{@base_title}"
    end
  end

end
