require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /top" do
    it "returns http success" do
      get "/home/top"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /privacy" do
    it "returns http success" do
      get "/home/privacy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /terms" do
    it "returns http success" do
      get "/home/terms"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /description" do
    it "returns http success" do
      get "/home/description"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /mypage" do
    it "returns http success" do
      get "/home/mypage"
      expect(response).to have_http_status(:success)
    end
  end

end
