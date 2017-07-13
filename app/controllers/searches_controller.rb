class SearchesController < ApplicationController
  def new
    types = serializer.serialize params[:types]

    redirect_to action: :show, query: params[:query], types: types
  end

  def show
    types = Searches::TypesSerializer.deserialize params[:types]

    search = SearchService.new(params[:query], types)
    @results = search.call
  end

  private

  def serializer
    Searches::TypesSerializer.new(all_types: SearchService::TYPES)
  end
end
