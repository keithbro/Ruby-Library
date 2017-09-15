module FatZebra
  ##
  # == FatZebra \Batch
  #
  # Manage Batch for the API
  #
  # * create
  # * search
  # * find
  # * result
  #
  class Batch < APIResource
    @resource_name = 'batches'

    include FatZebra::APIOperation::Search
    include FatZebra::APIOperation::Find
    include FatZebra::APIOperation::Save
    include FatZebra::APIOperation::Delete

    validates :filename, required: true, class_type: String, on: :create
    validates :file, required: true, class_type: File, on: :create
    validates :multipart, required: true, class_type: TrueClass, on: :create

    class << self

      ##
      # Upload a batch file
      #
      # @param [Hash] params for the request
      # @param [Hash] Additional options for the request
      #
      # @return [FatZebra::Batch] response from the API
      def create(params, options = {})
        params[:multipart] = true
        params[:content_type] = 'text/csv'
        params[:file] = File.new(params.delete(:path)) if params.key?(:path)

        super(params, options)
      end

    end

    ##
    # Return result from the batch
    #
    # @param [Hash] params for capture API (Optional)
    # @param [Hash] options for the request, and configurations (Optional)
    #
    # @return [String] formated as CSV
    def result(params = {}, options = {})
      request(:get, "#{resource_path}/#{id}/result.csv", params, options)
    rescue FatZebra::RequestError => error
      return error.http_body if error.http_status == 422
      raise
    end

  end
end