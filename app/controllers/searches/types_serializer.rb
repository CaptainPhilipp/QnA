module Searches
  class TypesSerializer
    TYPES_DELIMETER = ','.freeze

    def self.serialize(types)
      [*types] * TYPES_DELIMETER
    end

    def self.deserialize(types)
      types.split TYPES_DELIMETER
    end
  end
end
