class FilesController < ApplicationController
  before_action :authenticate_user!

  helper_method :file

  def destroy
    # record -- связанная модель к которой прикреплён файл
    file.purge if current_user.author_of?(file.record)
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:id])
  end
end
