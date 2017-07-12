class SearchesController < ApplicationController
  def search
    search = SearchService.new(params[:query], params[:types])
    @results = search.call
  end
end
