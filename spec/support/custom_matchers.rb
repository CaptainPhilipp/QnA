# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :change_results do |entity, any: nil, all: nil|
  match do |block|
    raise ArgumentError, '`all: []` OR `any: []` required' if all && any || !all && !any
    check, *methods = all ? [:all?, *all] : [:any?, *any]

    old_results = methods.map { |method| entity.send method }
    block.call
    entity.try :reload

    methods.zip(old_results).to_h.send(check) do |method, old_result|
      old_result != entity.send(method)
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
