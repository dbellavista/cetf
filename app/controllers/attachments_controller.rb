class AttachmentsController < ApplicationController

  def show
    attachment = Attachment.find(params[:id])
    send_file attachment.file, :filename => attachment.name
  end

end
