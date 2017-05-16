require 'rspec/expectations'

RSpec::Matchers.define :change_any_result do |entity, *fields|
    old_values = fields.map { |field| entity.send field }

    match do |actual|
      actual.call
      entity.reload
      fields.zip(old_values).any? do |pair|
        new_value = entity.send(pair.first)
        old_value = pair.last
        new_value != old_value
      end
    end

    supports_block_expectations
end
