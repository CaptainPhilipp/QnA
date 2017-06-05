require 'rails_helper'

describe 'Rateable concern' do
  with_model :RateableDouble do
    table do |t|
      t.integer :user_id
    end

    model do
      include Rateable

      belongs_to :user
    end
  end

  assign_users :owner_user, :user

  let(:rateable) { RateableDouble.create user: owner_user }

  it '#voices instance should be a new Voice' do
    expect(rateable.voices.build).to be_a_new Voice
  end

  it '#users instance should be a new User' do
    expect(rateable.user).to be_a User
  end

  context '#rating' do
    it 'should show rating of current record' do
      10.times { rateable.voices.create(user: create(:user), value: 1) }
      expect(rateable.rating).to eq 10
      3.times  { rateable.voices.create(user: create(:user), value: -1) }
      expect(rateable.rating).to eq 7
    end
  end

  context '#vote!' do
    it "owner can't rate his rateable" do
      rateable.vote!(1, owner_user)
      expect(rateable.rating).to eq(0)
    end

    it 'can rate down rateable' do
      rateable.vote!(-1, user)
      expect(rateable.rating).to eq(-1)
    end

    it "can't rate down rateable twice" do
      rateable.vote!('-1', user)
      rateable.vote!('-1', user)
      expect(rateable.rating).to eq(-1)
    end

    it 'can rate up rateable' do
      rateable.vote!('1', user)
      expect(rateable.rating).to eq(1)
    end

    it "can't rate up rateable twice" do
      rateable.vote!('1', user)
      rateable.vote!('1', user)
      expect(rateable.rating).to eq(1)
    end

    it "can't change voice without abort" do
      rateable.vote!('1', user)
      rateable.vote!('-1', user)
      expect(rateable.rating).to eq(1)
    end

    it "can cancel his voice" do
      rateable.vote!('1', user)
      rateable.vote!('0', user)
      expect(rateable.rating).to eq(0)
    end

    it "can't change others voices" do
      rateable.vote!('1', create(:user))
      rateable.vote!('0', user)
      expect(rateable.rating).to eq(1)
    end
  end
end
