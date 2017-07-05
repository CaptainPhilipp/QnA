shared_examples_for 'Contains associations' do |associations_list|
  associations_list.each do |association|
    it "question contains #{association}" do
      expect(response.body).to have_json_size(count).at_path(association)
    end
  end
end
