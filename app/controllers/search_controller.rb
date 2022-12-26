class SearchController < ApplicationController
  skip_authorization_check

  def index
    @result = SearchService.call(search_params)
  end

  private

  def search_params
    params.permit(:search_query, :search_by)
  end
end
