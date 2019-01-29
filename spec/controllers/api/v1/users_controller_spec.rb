require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'Get #show' do
    before :each do
      @user = create :user
      get :show, params: { id: @user.id }
    end

    it { should respond_with 200 }

    it 'returns a user reponse' do
      json_response = JSON.parse response.body, symbolize_names: true
      expect(json_response[:email]).to eq @user.email
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
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:email]).to eq @user_attributes[:email]
      end
    end

    context 'when cfreated failed' do
      before :each do
        @invalid_user_attributes = { password: '123456', password_confirmation: '123456' }
        post :create, params: { user: @invalid_user_attributes }
      end

      it { should respond_with 422 }

      it 'render errors json' do
        # binding.pry
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response).to have_key(:errors)
      end

      it 'render errors json with details message' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors][:email]).to include("can't be blank")
      end
    end
  end

  describe 'Put #update' do
    context 'when updated successfully' do
      before :each do
        @user = create :user
        @user_attributes = { email: 'newtest@sudiyi.cn' }
        put :update, params: { id: @user.id, user: @user_attributes }
      end

      it { should respond_with 200 }

      it 'returns a user reponse' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:email]).to eq @user_attributes[:email]
      end
    end

    context 'when email is nil, it should be updated failed' do
      before :each do
        @user = create :user
        @user_attributes = { email: nil }
        put :update, params: { id: @user.id, user: @user_attributes }
      end

      it { should respond_with 422 }

      it 'render errors json' do
        # binding.pry
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response).to have_key(:errors)
      end

      it 'render errors json with details message' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors][:email]).to include("can't be blank")
      end
    end

    context 'when id not exists, it should be updated failed' do
      before :each do
        @user_attributes = { email: 'newtest@sudiyi.cn' }
        put :update, params: { id: 0, user: @user_attributes }
      end

      it { should respond_with 404 }

      it 'render errors json' do
        # binding.pry
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response).to have_key(:errors)
      end

      it 'render errors json with details message' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors]).to include("not found")
      end
    end
  end

  describe 'Delete #destroy' do
    context 'when destroy successfully' do
      before :each do
        @user = create :user
        delete :destroy, params: { id: @user.id }
      end

      it { should respond_with 204 }
    end

    context 'when destroy failed' do
      before :each do
        delete :destroy, params: { id: 0 }
      end

      it { should respond_with 404 }

      it 'render errors json' do
        # binding.pry
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response).to have_key(:errors)
      end

      it 'render errors json with details message' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors]).to include("not found")
      end
    end
  end
end
