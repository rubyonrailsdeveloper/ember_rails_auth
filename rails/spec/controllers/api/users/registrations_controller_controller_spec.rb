require 'rails_helper'

RSpec.describe Api::Users::RegistrationsControllerController, type: :controller do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST users#sign_up" do

    context "valid user credentials" do
      before do
        post :create, user: {email: "foo@bar.com", password: "foofoobar"}
      end

      it "creates the user" do
        expect(response.created?).to eq true
      end

      it "logs in the user" do
        expect(subject.current_user.nil?).to eq false
      end
    end
  end

  context "user already created" do
    before do
      @user = User.create(email: "foo@bar.com", password: "foofoobar")

      post :create, user: {email: @user.email, password: @user.password}
    end

    it "does not create the user" do
      expect(response.unauthorized?).to eq true
    end

    it "should not log in the user" do
      expect(subject.current_user.nil?).to eq true
    end
  end

end
