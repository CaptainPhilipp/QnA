module Searches
  class TypesSerializer
    TYPES_DELIMETER = ','.freeze

    def initialize(all_types:)
      @all_types = all_types
    end

    def serialize(types)
      return all_types if types.nil?
      [*types] * TYPES_DELIMETER
    end

    def self.deserialize(types)
      types.split TYPES_DELIMETER
    end

    private

    def all_types
      @all_types * TYPES_DELIMETER
    end
  end
end
