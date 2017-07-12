# frozen_string_literal: true

shared_examples_for 'Contains fields' do |record_name, fields_list, predicate|
  fields_list.each do |field|
    it "#{record_name} contains #{field} field" do
      record = send(record_name)
      field_path = "#{predicate || ''}#{field}"
      expect(response.body).to be_json_eql(record.send(field).to_json).at_path(field_path)
    end
  end
end
