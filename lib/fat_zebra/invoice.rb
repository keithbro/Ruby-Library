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
  class Invoice < APIResource
    @resource_name = 'invoices'
    include FatZebra::APIOperation::Find

    class << self
      def create(params = {}, options = {})
        params[:content_type] = 'text/csv'
        params[:file] = File.new(params.delete(:path)) if params.key?(:path)

        valid!(params, :create) if respond_to?(:valid!)

        response = request(:put, resource_path, params, options)
        initialize_from(response)
      end
    end
  end
end
