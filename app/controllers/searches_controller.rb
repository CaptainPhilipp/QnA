class SearchesController < ApplicationController
  def new
    types = SearchService.serialize_types(params[:types])
    redirect_to action: :show, query: params[:query], types: types
  end

  def show
    types   = SearchService.deserialize_types(params[:types])
    search = SearchService.new(params[:query], types)
    @results = search.call
  end
end
