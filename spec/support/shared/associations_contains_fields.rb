# frozen_string_literal: true

shared_examples_for 'Associations contains field' do |associations|
  associations.each do |association, field|
    it "#{association} association contains #{field}" do
      expect(response.body).to be_json_eql(send(association).last.send(field).to_json)
        .at_path("#{association}/0/#{field}")
    end
  end
end
