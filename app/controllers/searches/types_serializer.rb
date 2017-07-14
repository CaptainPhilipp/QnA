module Searches
  class TypesSerializer
    TYPES_DELIMETER = ','.freeze
    ALL_KEY = 'All'.freeze

    class << self
      def serialize(types)
        return ALL_KEY if types.nil?
        [*types].join TYPES_DELIMETER
      end

      def deserialize(types)
        return nil if types == ALL_KEY
        types.split TYPES_DELIMETER
      end
    end
  end
end
