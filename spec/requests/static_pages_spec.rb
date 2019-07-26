require 'rails_helper'

RSpec.describe StaticPagesController, type: :request do

  before(:all) {
    @base_title = "Ruby on Rails Tutorial Sample App"
  }

  describe "GET static pages" do
    it "root returns http success" do
      get root_path
      expect(response.status).to eq 200
      expect(response.body).to include("#{@base_title}")
    end

    it "help page returns http success" do
      get help_path
      expect(response.status).to eq 200
      expect(response.body).to include "Help | #{@base_title}"
    end

    it "about page returns http success" do
      get about_path
      expect(response.status).to eq 200
      expect(response.body).to include "About | #{@base_title}"
    end

    it "contact page returns http success" do
      get contact_path
      expect(response.status).to eq 200
      expect(response.body).to include "Contact | #{@base_title}"
    end
  end

end
