# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchService do
  let(:query) { 'Search query' }
  let(:right_types) { %w[Question Answer Comment] }

  let(:service) { SearchService.new(query, types) }
  let(:sphinx)  { ThinkingSphinx }

  context 'with right types' do
    let(:types) { %w[Question Answer] }
    let(:classes) { types.map(&:constantize) }

    it 'calls Sphinx with right query and types' do
      expect(sphinx).to receive(:search).with(query, classes: classes)
      service.call
    end
  end

  context 'without types' do
    let(:types) {}

    it 'calls Sphinx with right without types' do
      expect(sphinx).to receive(:search).with(query)
      service.call
    end
  end

  context 'calls Sphinx with wrong and right types' do
    let(:types) { %w[YourMom SomeOtherType] + right_types }
    let(:classes) { right_types.map(&:constantize) }

    it 'calls Sphinx with right query and types' do
      expect(sphinx).to receive(:search).with(query, classes: classes)
      service.call
    end
  end

  context 'calls Sphinx only with wrong types' do
    let(:types) { %w[YourMom SomeOtherType] }

    it 'calls Sphinx with right query and types' do
      expect(sphinx).to receive(:search).with(query)
      service.call
    end
  end
end
