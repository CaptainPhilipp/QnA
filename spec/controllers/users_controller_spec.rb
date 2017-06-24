require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #email" do
    it "returns http success" do
      get :email
      expect(response).to have_http_status(:success)
    end
  end

end
