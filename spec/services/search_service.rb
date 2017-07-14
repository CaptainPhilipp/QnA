# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchService do
  let(:query) { 'Search query' }
  let(:right_types) { %w[Question Answer Comment] }

  let(:service) { SearchService.new(query, types) }
  let(:sphinx)  { ThinkingSphinx }

  context 'with right types' do
    let(:types) { %w[Question Answer] }

    it 'calls Sphinx with right query and types' do
      expect(sphinx).to recieve(:search).with(query, types)
    end
  end

  context 'without types' do
    let(:types) {}

    it 'calls Sphinx with right without types' do
      expect(sphinx).to recieve(:search).with(query)
    end
  end

  context 'calls Sphinx with wrong and right types' do
    let(:types) { %w[YourMom SomeOtherType] + right_types }

    it 'calls Sphinx with right query and types' do
      expect(sphinx).to recieve(:search).with(query, right_types)
    end
  end

  context 'calls Sphinx only with wrong types' do
    let(:types) { %w[YourMom SomeOtherType] }

    it 'calls Sphinx with right query and types' do
      expect(sphinx).to recieve(:search).with(query)
    end
  end
end
