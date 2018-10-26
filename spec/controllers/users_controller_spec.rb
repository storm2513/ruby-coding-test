require 'rails_helper'

describe UsersController do
  describe 'GET index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'returns response status 200' do
      get :index
      expect(response.status).to eq(200)
    end

    it 'gets all users' do
      3.times do
        create(:user)
      end

      get :index
      expect(assigns(:users)).to eq(User.all)
    end
  end

  describe 'GET show' do
    let(:user) { create(:user) }

    it 'renders the show template' do
      get :show, params: { id: user.id }
      expect(response).to render_template('show')
    end

    it 'returns response status 200' do
      get :show, params: { id: user.id }
      expect(response.status).to eq(200)
    end

    it 'returns not found' do
      get :show, params: { id: 1000 }
      expect(response.body).to eq('Not Found')
    end

    it 'assigns @user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end

    it 'returns response status 200' do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe 'GET edit' do
    let(:user) { create(:user) }

    it 'renders the edit template' do
      get :edit, params: { id: user.id }
      expect(response).to render_template('edit')
    end

    it 'returns response status 200' do
      get :edit, params: { id: user.id }
      expect(response.status).to eq(200)
    end

    it 'assigns @user' do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST create' do
    let(:user) { attributes_for(:user) }

    it 'renders the new template if user invalid' do
      user[:email] = ''
      post :create, params: { user: user }
      expect(response).to render_template('new')
    end

    it 'redirects to user path' do
      post :create, params: { user: user }
      expect(response).to redirect_to(user_url(assigns(:user)))
    end

    it 'creates user' do
      post :create, params: { user: user }
      expect(assigns(:user).admin?).to eq(false)
      expect(assigns(:user).customer?).to eq(false)
      expect(User.count).to eq(1)
    end

    it 'assigns roles' do
      user[:admin] = '1'
      user[:customer] = '1'
      post :create, params: { user: user }
      expect(assigns(:user).admin?).to eq(true)
      expect(assigns(:user).customer?).to eq(true)
    end
  end

  describe 'PATCH update' do
    let(:user) { create(:user) }
    let(:user_attributes) { attributes_for(:user) }

    it 'renders the edit template if user invalid' do
      user_attributes[:email] = ''
      patch :update, params: { user: user_attributes, id: user.id }
      expect(response).to render_template('edit')
    end

    it 'redirects to user path' do
      patch :update, params: { user: user_attributes, id: user.id }
      expect(response).to redirect_to(user_url(assigns(:user)))
    end

    it 'updates user' do
      user_attributes[:email] = 'example@example.org'
      patch :update, params: { user: user_attributes, id: user.id }
      expect(User.find(user.id).email).to eq('example@example.org')
    end

    it 'assigns roles' do
      user_attributes[:admin] = '1'
      user_attributes[:customer] = '1'
      patch :update, params: { user: user_attributes, id: user.id }
      expect(assigns(:user).admin?).to eq(true)
      expect(assigns(:user).customer?).to eq(true)
    end

    it 'returns not found' do
      patch :update, params: { user: user_attributes, id: 1000 }
      expect(response.body).to eq('Not Found')
    end
  end

  describe 'DELETE destroy' do
    let(:user) { create(:user) }

    it 'shows success notice' do
      delete :destroy, params: { id: user.id }
      expect(flash[:notice]).to eq('User was successfully destroyed.')
    end

    it 'deletes user' do
      delete :destroy, params: { id: user.id }
      expect(User.where(id: user.id).count).to eq(0)
    end

    it 'shows error notice' do
      user.grant(:admin)
      delete :destroy, params: { id: user.id }
      expect(flash[:notice]).to eq('Cannot delete user: user is admin.')
    end

    it 'does not delete user' do
      user.grant(:admin)
      delete :destroy, params: { id: user.id }
      expect(User.where(id: user.id).count).to eq(1)
    end

    it 'returns not found' do
      delete :destroy, params: { id: 1000 }
      expect(response.body).to eq('Not Found')
    end
  end
end
