class SearchesController < ApplicationController
  def create
    types = Searches::TypesSerializer.serialize params[:types]

    redirect_to action: :show, query: params[:query], types: types
  end

  def show
    types = Searches::TypesSerializer.deserialize params[:types]

    search = SearchService.new(params[:query], types)
    @results = search.call
  end
end
