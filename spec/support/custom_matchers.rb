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

RSpec::Matchers.define :allow do |*actions|

  match do |policy|
    @failed_actions = []

    actions.each do |action|
      failed_actions << action unless policy.public_send("#{action}?")
    end

    failed_actions.empty?
  end

  failure_message do |policy|
    error_messages_for('permit', policy)
  end

  failure_message_when_negated do |policy|
    error_messages_for('forbid', policy)
  end

  private

  attr_reader :failed_actions

  def error_messages_for(text, policy)
    failed_actions.map! do |action|
      "#{policy.class} does not #{text} #{action} on #{policy.record} for #{policy.user.inspect}."
    end

    failed_actions * "\n"
  end
end
