require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'Get #show' do
    before :each do
      @user = create :user
      4.times { create :toy, user: @user }
      get :show, params: { id: @user.id }
    end

    it { should respond_with 200 }

    it 'returns a user reponse' do
      # binding.pry
      expect(json_response[:data][:attributes][:email]).to eq @user.email
    end

    it "should returns toys in user" do
      # binding.pry
      expect(json_response[:data][:relationships][:toys][:data].count).to eq @user.toys.count
    end
  end

  describe 'Post #create' do
    context 'when created successfully' do
      before :each do
        @user_attributes = attributes_for :user
        post :create, params: { user: @user_attributes }
      end

      it { should respond_with 201 }

      it 'returns the user record just created' do
        expect(json_response[:data][:attributes][:email]).to eq @user_attributes[:email]
      end
    end

    context 'when created failed' do
      before :each do
        @invalid_user_attributes = { password: '123456', password_confirmation: '123456' }
        post :create, params: { user: @invalid_user_attributes }
      end

      it { should respond_with 422 }

      it 'render errors json' do
        # binding.pry
        expect(json_response).to have_key(:errors)
      end

      it 'render errors json with details message' do
        # binding.pry
        expect(json_response[:errors].first[:detail]).to include("can't be blank")
      end
    end
  end

  describe 'Put #update' do
    context 'when updated successfully' do
      before :each do
        @user = create :user
        api_authorization_header @user.auth_token
        @user_attributes = { email: 'newtest@sudiyi.cn' }
        put :update, params: { id: @user.id, user: @user_attributes }
      end

      it { should respond_with 200 }

      it 'returns a user reponse' do
        expect(json_response[:data][:attributes][:email]).to eq @user_attributes[:email]
      end
    end

    context 'when email is nil, it should be updated failed' do
      before :each do
        @user = create :user
        api_authorization_header @user.auth_token
        @user_attributes = { email: nil }
        put :update, params: { id: @user.id, user: @user_attributes }
      end

      it { should respond_with 422 }

      it 'render errors json' do
        # binding.pry
        expect(json_response).to have_key(:errors)
      end

      it 'render errors json with details message' do
        expect(json_response[:errors].first[:detail]).to include("can't be blank")
      end
    end

    context 'when id not exists, it should be updated failed' do
      before :each do
        @user_attributes = { email: 'newtest@sudiyi.cn' }
        put :update, params: { id: 0, user: @user_attributes }
      end

      it { should respond_with 401 }

      it 'render errors json' do
        # binding.pry
        expect(json_response).to have_key(:errors)
      end

      it 'render errors json with details message' do
        expect(json_response[:errors]).to include("Not authenticated")
      end
    end
  end

  describe 'Delete #destroy' do
    context 'when destroy successfully' do
      before :each do
        @user = create :user
        api_authorization_header @user.auth_token
        delete :destroy, params: { id: @user.id }
      end

      it { should respond_with 204 }
    end

    context 'when destroy failed' do
      before :each do
        delete :destroy, params: { id: 0 }
      end

      it { should respond_with 401 }

      it 'render errors json' do
        # binding.pry
        expect(json_response).to have_key(:errors)
      end

      it 'render errors json with details message' do
        expect(json_response[:errors]).to include("Not authenticated")
      end
    end
  end
end
