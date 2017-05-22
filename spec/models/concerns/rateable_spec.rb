require 'rails_helper'

describe 'Rateable concern' do
  with_model :RateableDouble do
    table do |t|
      t.integer :user_id
    end

    model do
      include HasUser
      include Rateable
    end
  end

  assign_user

  let(:rateable) { RateableDouble.create user: user }

  it '#voices instance should be a new Voice' do
    expect(rateable.voices.build).to be_a_new Voice
  end

  it '#users instance should be a new User' do
    expect(rateable.user).to be_a User
  end

  context '#rating' do
    it 'should show rating of current record' do
      expect(rateable.rating).to eq 0
      10.times { rateable.voices.create(user: create(:user), value: 1) }
      expect(rateable.rating).to eq 10
      3.times  { rateable.voices.create(user: create(:user), value: -1) }
      expect(rateable.rating).to eq 7
    end
  end

  context '#rate_up_by' do
    it 'can rate up the answer' do
      rateable.rate_up_for(user)
      expect(rateable.rating).to eq 1
    end

    it "can't change rating twice" do
      rateable.voices.create(user: create(:user), value: 1)
      rateable.rate_up_for(user)
      expect(rateable.rating).to eq 1
    end
  end

  context '#rate_down_by' do
    it 'can rate down rateable' do
      rateable.rate_down_for(user)
      expect(rateable.rating).to eq(-1)
    end

    it "can rate down rateable twice" do
      rateable.voices.create(user: create(:user), value: -1)
      rateable.rate_down_for(user)
      expect(rateable.rating).to eq(-1)
    end
  end

  context '#cancel_voice' do
    it "cant change voices" do
      rateable.voices.create(user: create(:user), value: 1)
      rateable.cancel_voice
      expect(rateable.rating).to eq(1)
    end

    it "can cancel his voice" do
      rateable.voices.create(user: create(:user), value: 1)
      rateable.cancel_voice
      expect(rateable.rating).to eq(0)
    end
  end
end
