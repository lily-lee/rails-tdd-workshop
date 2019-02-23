require 'rails_helper'

class Authentication < ApplicationController
  include Authenticable
end

RSpec.describe Authenticable do
  let(:authentications) { Authentication.new }
  subject { authentications }

  describe '#current_user' do
    before :each do
      @user = create :user
      request.headers['Authorization'] = @user.auth_token
      allow(authentications).to receive(:request).and_return(request)
    end

    it "should returns the user from authorization header" do
      expect(authentications.current_user.auth_token).to eq @user.auth_token
    end
  end
end
