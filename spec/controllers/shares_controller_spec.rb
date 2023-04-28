require 'rails_helper'

RSpec.describe SharesController do
  let(:video){FactoryBot.create :video}

  describe "GET shares#new" do
    context "when user not logged in" do
      it "should return home" do
        get :new

        expect(response).to redirect_to(root_path)
      end
    end

    context "when user logged in" do
      before do
        @request.session[:user_id] = video.user.id
      end

      it "should return home" do
        get :new

        expect(response).to render_template :new
      end
    end
  end

  describe "POST shares#create" do
    context "when user not logged in" do
      it "should return home" do
        post :create

        expect(response).to redirect_to(root_path)
      end
    end

    context "when user logged in" do
      before do
        @request.session[:user_id] = video.user.id
      end

      context "when video was shared" do
        it "return error" do
          post :create, params: {url: "https://youtu.be/#{video.video_id}"}
    
          aggregate_failures do
            expect(flash[:danger]).to be_present
            expect(response).to redirect_to new_shares_path
          end
        end
      end

      context "when get video info return blank" do
        before do
          stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=asdasdw&key=#{ENV["API_KEY"]}&part=snippet")
            .with(
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Host'=>'www.googleapis.com',
                'User-Agent'=>'rest-client/2.1.0 (linux x86_64) ruby/3.2.2p53'}
            ).to_return(status: 200, body: {}.to_json, headers: {})
        end

        it "return error" do
          post :create, params: {url: "abc.com/asdasdw"}
    
          aggregate_failures do
            expect(flash[:danger]).to be_present
            expect(response).to redirect_to new_shares_path
          end
        end
      end

      context "when get video info return data" do
        before do
          stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=asdasdw&key=AIzaSyCex9Ka5iGzKL78vzFOrTWELHutwyrdpOM&part=snippet")
            .with(
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Host'=>'www.googleapis.com',
                'User-Agent'=>'rest-client/2.1.0 (linux x86_64) ruby/3.2.2p53'}
            ).to_return(
              status: 200,
              body: {
                items: [
                  {
                    snippet: {
                      title: "abc",
                      description: "xasasd"
                    }
                  }
                ]
              }.to_json,
              headers: {}
            )
        end

        context "when save success" do
          it "return success" do
            post :create, params: {url: "abc.com/asdasdw"}
      
            aggregate_failures do
              expect(flash[:success]).to be_present
              expect(response).to redirect_to root_path
              expect(Video.last.title).to eq "abc"
            end
          end
        end

        context "when save failed" do
          before do
            allow_any_instance_of(Video).to receive(:save).and_return false
          end

          it "return error" do
            post :create, params: {url: "abc.com/asdasdw"}
      
            aggregate_failures do
              expect(flash[:danger]).to be_present
              expect(response).to redirect_to new_shares_path
            end
          end
        end
      end
    end
  end
end
