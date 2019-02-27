require 'rails_helper'

RSpec.describe Api::V1::ToysController, type: :controller do
  describe 'Get #show' do
    before :each do
      @toy = create :toy
      get :show, params: { id: @toy.id }
    end

    it { should respond_with 200 }

    it 'should returns a toy response' do
      expect(json_response[:data][:attributes][:user_id]).to eq @toy.user_id
      expect(json_response[:data][:attributes][:title]).to eq @toy.title
      expect(json_response[:data][:attributes][:price]).to eq @toy.price.round(2).to_s
      expect(json_response[:data][:attributes][:published]).to eq @toy.published
    end
    it 'should returns user relationships in toy' do
      # binding.pry
      expect(json_response[:data][:relationships][:user][:data][:id].to_i).to eq @toy.user.id
    end
  end

  describe 'Post #create' do
    context 'create success' do
      before :each do
        @user = create :user
        api_authorization_header @user.auth_token
        toy_attributes = { title: "test" }
        post :create, params: { toy: toy_attributes, user_id: @user.id }
      end

      it { should respond_with 201 }
    end

    context 'create failed' do
      before :each do
        @user = create :user
        api_authorization_header @user.auth_token
        toy_attributes = { price: 0.0 }
        post :create, params: { toy: toy_attributes, user_id: @user.id }
      end

      it { should respond_with 422 }
    end
  end

  describe 'Put #update' do
    context 'Update success' do
      before :each do
        @user = create :user
        @toy = create :toy, user: @user
        api_authorization_header @user.auth_token
        toy_attributes = { title: 'new title' }
        put :update, params: { id: @toy.id, toy: toy_attributes, user_id: @user.id }
      end

      it { should respond_with 200 }

      it 'should returns a toy response' do
        expect(json_response[:data][:attributes][:user_id]).to eq @toy.user_id
        expect(json_response[:data][:attributes][:title]).to eq 'new title'
        expect(json_response[:data][:attributes][:price]).to eq @toy.price.round(2).to_s
        expect(json_response[:data][:attributes][:published]).to eq @toy.published
      end
      it 'should returns user relationships in toy' do
        expect(json_response[:data][:relationships][:user][:data][:id].to_i).to eq @toy.user.id
      end
    end

    context 'Update failed' do
      before :each do
        @user = create :user
        @toy = create :toy, user: @user
        api_authorization_header @user.auth_token
        toy_attributes = { title: '' }
        put :update, params: { id: @toy.id, toy: toy_attributes, user_id: @user.id }
      end

      it { should respond_with 422 }

      it 'should returns error' do
        expect(json_response[:errors].first[:detail]).to include("can't be blank")
      end
    end


  end

  describe 'Delete #destroy' do
    context 'Delete success' do
      before :each do
        @user = create :user
        @toy = create :toy, user: @user
        api_authorization_header @user.auth_token
        delete :destroy, params: { id: @toy.id, user_id: @user.id }
      end

      it { should respond_with 204 }
    end

    context 'Update failed' do
    end
  end

  describe 'Get #index' do
    context 'Get success' do
    end

    context 'Get failed' do
    end
  end
end
