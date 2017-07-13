class SearchService
  TYPES = %w[Question Answer Comment].freeze
  TYPES_DELIMETER = ','.freeze

  def initialize(query, types)
    @query = query
    @types = types || []
  end

  def call
    @types.empty? ? search : search(classes: classes)
  end

  def self.serialize_types(types)
    [*types] * TYPES_DELIMETER
  end

  def self.deserialize_types(types)
    types.split TYPES_DELIMETER
  end

  private

  def search(*args)
    ThinkingSphinx.search(escaped_query, *args)
  end

  def classes
    permit_types.map(&:constantize)
  end

  def permit_types
    TYPES & @types
  end

  def escaped_query
    ThinkingSphinx::Query.escape(@query)
  end
end
