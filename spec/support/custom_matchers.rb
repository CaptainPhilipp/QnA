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

RSpec::Matchers.define :allow do |action|
  match do |policy|
    policy.public_send("#{action}?")
  end

  failure_message_for_should do |policy|
    "#{policy.class} does not permit #{action} on #{policy.record} for #{policy.user.inspect}."
  end

  failure_message_for_should_not do |policy|
    "#{policy.class} does not forbid #{action} on #{policy.record} for #{policy.user.inspect}."
  end
end
