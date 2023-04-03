require "rails_helper"

# NOTE: in deployed environments, this interaction is handled by Apache and
#       Shibboleth in concert with the application
RSpec.describe "User authentication", type: :request do
  context "with unauthenticated user" do
    before do
      sign_out
    end

    it "redirects from /webauth/login to root without a cookie" do
      get "/webauth/login"
      expect(response).to have_http_status(:found)
      expect(response.headers["Set-Cookie"]).to be_nil
      expect(response).to redirect_to(root_path)
    end

    it "redirects from /webauth/logout to root" do
      get "/webauth/logout"
      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(root_path)
    end
  end

  context "with authenticated user" do
    let(:user) do
      User.new(email: "mjgiarlo@stanford.edu")
    end

    before do
      sign_in user
    end

    it "redirects from /webauth/login to root with a cookie" do
      get "/webauth/login"
      expect(response).to have_http_status(:found)
      expect(response.headers["Set-Cookie"]).to start_with("_dataloading_management_session=")
      expect(response).to redirect_to(root_path)
    end

    it "redirects from /webauth/logout to configured logout URL" do
      get "/webauth/logout"
      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(DeviseRemoteUser.logout_url)
    end
  end
end
