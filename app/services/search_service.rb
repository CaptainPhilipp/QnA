class SearchService
  TYPES = %w[Question Answer Comment User].freeze

  def initialize(query, types)
    @query = query
    @types = types
  end

  def call
    permited_types.empty? ? search : search(classes: classes)
  end

  private

  attr_reader :query

  def search(*args)
    ThinkingSphinx.search(escaped_query, *args)
  end

  def classes
    permited_types.map(&:constantize)
  end

  def permited_types
    @permited_types ||= TYPES & types
  end

  def escaped_query
    ThinkingSphinx::Query.escape(query)
  end

  def types
    @types ||= []
  end
end
