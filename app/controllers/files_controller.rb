class FilesController < ApplicationController
  before_action :authenticate_user!

  helper_method :file

  def destroy
    authorize! :destroy, file

    file.purge
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:id])
  end
end
