require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  assign_users

  let(:question) { create :question, user: user }
  let(:answer)   { create :answer,   user: user }
  let(:comment)  { create :comment,  user: user }

  context 'Guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  context 'User can read and create' do
    it { should be_able_to [:read, :create], Question }
    it { should be_able_to [:read, :create], Answer }
    it { should be_able_to [:read, :create], Comment }
  end

  context 'User can manage his records' do
    it { should be_able_to [:edit, :destroy], question, user_id: user.id }
    it { should be_able_to [:edit, :destroy], answer,   user_id: user.id }
    it { should be_able_to [:edit, :destroy], comment,  user_id: user.id }
  end

  context "User can't manage not his records" do
    # Не понимаю что творится с проверкой id. Судя по результатам, объект всегда отличается
    it { should_not be_able_to [:edit, :destroy], question, user_id: other_user.id }
  end

  context "rateable" do
    let(:rateable) { question }

    it 'User can vote for others records' do
      # Тут то-же самое (32 строка)
      should be_able_to(:vote, rateable) { |voteable| voteable.user_id != user.id }
    end

    it 'User cant vote for his records' do
      should_not be_able_to(:vote, rateable) { |voteable| voteable.user_id == user.id }
    end
  end
end
