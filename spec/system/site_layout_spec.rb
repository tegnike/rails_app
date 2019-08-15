# frozen_string_literal: true

require "rails_helper"

RSpec.describe "StaticPages", type: :system, js: true do
  describe "Home page" do
    before do
      visit root_path
    end

    it "should have the content 'StaticPages#home'" do
      expect(page).to have_selector "h1", text: "Sample App"
    end

    it "should have the right title" do
      expect(page).to have_title full_title("")
    end
  end
end
