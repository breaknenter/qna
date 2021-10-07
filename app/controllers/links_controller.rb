class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    link.destroy if current_user.author_of?(link.question)
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end
end
