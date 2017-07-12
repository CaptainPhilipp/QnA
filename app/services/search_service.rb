class SearchService
  TYPES = %w[Question Answer Comment].freeze

  def initialize(query, types)
    @query = query
    @types = types || []
  end

  def call
    @types.empty? ? search : search(classes: classes)
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
