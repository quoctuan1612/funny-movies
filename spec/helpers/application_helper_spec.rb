require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper do
  describe "#current_user" do
    let(:user){FactoryBot.create :user}

    context "when user logged in" do
      before do
        @request.session[:user_id] = user.id
      end

      it "should return user" do
        expect(current_user).to eq user
      end
    end

    context "when user not logged in" do
      before do
        @request.session[:user_id] = nil
      end

      it "should return user" do
        expect(current_user).to eq nil
      end
    end
  end
end
