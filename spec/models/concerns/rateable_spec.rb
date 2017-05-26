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
      10.times { rateable.voices.create(user: create(:user), value: 1) }
      expect(rateable.rating).to eq 10
      3.times  { rateable.voices.create(user: create(:user), value: -1) }
      expect(rateable.rating).to eq 7
    end
  end

  context '#rate_up_by' do
    it 'can rate up the answer' do
      rateable.rate_up_by(user)
      expect(rateable.rating).to eq 1
    end

    it "can't change rating twice" do
      rateable.rate_up_by(user)
      rateable.rate_up_by(user)
      expect(rateable.rating).to eq 1
    end
  end

  context '#rate_down_by' do
    it 'can rate down rateable' do
      rateable.rate_down_by(user)
      expect(rateable.rating).to eq(-1)
    end

    it "can rate down rateable twice" do
      rateable.rate_down_by(user)
      rateable.rate_down_by(user)
      expect(rateable.rating).to eq(-1)
    end
  end

  context '#cancel_voice' do
    it "cant change others voices" do
      rateable.voices.create(user: create(:user), value: 1)
      rateable.cancel_voice_of(user)
      expect(rateable.rating).to eq(1)
    end

    it "can cancel his voice" do
      rateable.voices.create(user: user, value: 1)
      rateable.cancel_voice_of(user)
      expect(rateable.rating).to eq(0)
    end
  end

  context '#rated_by?' do
    it "should be false if user don't votes entity" do
      expect(rateable.rated_by? user).to be_falsy
    end

    it 'should be true if user votes for entity' do
      rateable.voices.create(user: user, value: 1)
      expect(rateable.reload.rated_by? user).to be true
    end

    it "should be false if user don't votes entity, but others do" do
      rateable.voices.create(user: create(:user), value: 1)
      expect(rateable.rated_by? user).to be_falsy
    end
  end
end
