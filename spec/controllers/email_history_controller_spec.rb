require 'rails_helper'

describe EmailHistoryController do
  describe 'GET index' do
    let(:user) { create(:user) }

    it 'assigns @user' do
      get :index, params: { user_id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the index template' do
      get :index, params: { user_id: user.id }
      expect(response).to render_template('index')
    end

    it 'returns response status 200' do
      get :index, params: { user_id: user.id }
      expect(response.status).to eq(200)
    end

    it 'gets email history' do
      3.times do
        user.email = Faker::Internet.safe_email
        user.save!
      end

      get :index, params: { user_id: user.id }
      expect(assigns(:versions).count).to eq(4)
    end
  end
end
