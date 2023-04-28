require 'rails_helper'

RSpec.describe SessionsController do
  let(:user){FactoryBot.create :user}
  describe "POST sessions#create" do
    describe "#login" do
      context "when params is valid" do
        let(:params) do
          {
            user_name: user.user_name,
            password: user.password
          }
        end

        it "should login success" do
          post :create, params: params

          aggregate_failures do
            expect(flash[:success]).to be_present
            expect(session[:user_id]).to eq user.id
          end
        end
      end

      context "when params is invalid" do
        let(:params) do
          {
            user_name: user.user_name,
            password: nil
          }
        end

        it "should login failed" do
          post :create, params: params

          aggregate_failures do
            expect(flash[:danger]).to be_present
            expect(session[:user_id]).to eq nil
          end
        end
      end
    end

    describe "#register" do
      context "when params is invalid"do
        let(:params) do
          {
            user_name: nil,
            password: "asd"
          }
        end
        
        it "should register failed" do
          post :create, params: params

          aggregate_failures do
            expect(flash[:danger]).to be_present
            expect(User.all.size).to eq 0
          end
        end
      end

      context "when params is valid"do
        let(:params) do
          {
            user_name: "user register",
            password: "asd"
          }
        end
        
        it "should register success" do
          post :create, params: params

          aggregate_failures do
            expect(flash[:success]).to be_present
            expect(User.all.size).to eq 1
            expect(User.first.user_name).to eq params[:user_name]
          end
        end
      end
    end
  end

  describe "GET sessions#logout" do
    context "when logout success" do
      before do
        @request.session[:user_id] = user.id
      end

      it "should session is nil" do
        get :logout

        expect(session[:user_id]).to eq nil
      end
    end
  end
end
