require 'rails_helper'

# shared_examples 'should cancel voice' do |rateable, vote_value|
#   expect(rateable.rated_by? user).to be true
#   post :vote, params: { id: rateable, value: vote_value }
#   expect(rateable.reload.rated_by? user).to be false
# end
#
# shared_examples 'should not change rating' do |rateable, vote_value|
#   expect(rateable.rating).to eq 1
#   post :vote, params: { id: rateable, value: vote_value }
#   expect(rateable.reload.rating).to eq 1
# end
#
# shared_examples 'should rate_up rateable entity' do |rateable, vote_value|
#   expect(rateable.rating).to eq 0
#   post :vote, params: { id: rateable, value: vote_value }
#   expect(rateable.reload.rating).to eq 1
# end
#
# shared_examples 'should rate_down rateable entity' do |rateable, vote_value|
#   expect(rateable.rating).to eq 0
#   post :vote, params: { id: rateable, value: vote_value }
#   expect(rateable.reload.rating).to eq(-1)
# end
