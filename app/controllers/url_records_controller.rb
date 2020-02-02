class UrlRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Assumption: Valid url characters are A-Z, a-z, 0-9, -, ., _, ~, :, /,
  # ?, #, [, ], @, !, $, &, ', (, ), *, +, ,, ;, %, and =
  def index
    existing_url = UrlRecord.find_by_url(params[:url])
  
    render json: existing_url
  end

  def create
    existing_record = UrlRecord.find_by_url(params[:url])
    url_record = existing_record&.empty? ? UrlRecord.create_record(params[:url]) : existing_record.first
    status_code = existing_record&.empty? ? :created : :ok

    render json: url_record, status: status_code
  end

  def stats
    existing_record = UrlRecord.find_by_shortened_url(params[:url])&.first
    return head(:not_found) if existing_record.nil?

    render json: existing_record&.num_visits
  end
  
  def redirect
    associated_entry = UrlRecord.find_by_shortened_url(params[:url])&.first
    return head(:not_found) if associated_entry.nil?
      
    associated_entry.increment_visit_statistics
    redirect_to associated_entry&.path
  end
end