require 'rspec/expectations'

RSpec::Matchers.define :not_change_fields do |entity, *messages|
    old_values = messages.map { |message| entity.send message }

    match do |actual|
      actual.call
      entity.reload
      messages.zip(old_values).all? do |pair|
        new_value = entity.send(pair.first)
        old_value = pair.last

        new_value == old_value
      end
    end

    supports_block_expectations
end
