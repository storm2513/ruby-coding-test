require 'rails_helper'

describe User, type: :model do
  context 'validations' do
    it 'validates fields presence' do
      record = User.new
      record.email = ''
      record.first_name = ''
      record.last_name = ''
      record.valid?
      expect(record.errors[:email]).to include("can't be blank")
      expect(record.errors[:first_name]).to include("can't be blank")
      expect(record.errors[:last_name]).to include("can't be blank")
    end

    it 'validates email correctness' do
      user = build(:user)
      user.email = 'email@example'
      user.valid?
      expect(user.errors[:email]).to include('is invalid')
    end

    it 'validates email uniqness' do
      user = build(:user)
      user.email = 'email@example.org'
      user.save
      new_user = build(:user)
      new_user.email = 'email@example.org'
      new_user.valid?
      expect(new_user.errors[:email]).to include('has already been taken')
    end
  end

  context 'methods' do
    describe ':admin?' do
      it 'returns true if user is admin' do
        user = create(:user)
        user.add_role(:admin)
        expect(user.admin?).to eq(true)
      end

      it 'returns false if user is not admin' do
        user = create(:user)
        expect(user.admin?).to eq(false)
      end
    end

    describe ':customer?' do
      it 'returns true if user is customer' do
        user = create(:user)
        user.add_role(:customer)
        expect(user.customer?).to eq(true)
      end

      it 'returns false if user is not customer' do
        user = create(:user)
        expect(user.customer?).to eq(false)
      end
    end
  end

  context 'versions' do
    it 'saves email versions' do
      user = create(:user)
      3.times do
        user.email = Faker::Internet.safe_email
        user.save!
      end
      expect(User.first.versions.length).to eq(4)
    end
  end
end
