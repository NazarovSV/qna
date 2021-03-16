class AttachmentFilesController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :load_attachment, only: :destroy

  def destroy
    @attachment.purge if current_user.author?(@attachment.record)
  end

  private

  def load_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
