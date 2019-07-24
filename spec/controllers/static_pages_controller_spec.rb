require 'rails_helper'

describe StaticPagesController do

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      expect(response.status).to eq 200
      expect(response.body).to have_title 'Home | Ruby on Rails Tutorial Sample App'
    end
  end

  describe "GET 'help'" do
    it "returns http success" do
      get 'help'
      expect(response.status).to eq 200
      expect(response.body).to have_title 'Help | #{@base_title}'
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      expect(response.status).to eq 200
      expect(response.body).to have_title 'About | #{@base_title}'
    end
  end

end
