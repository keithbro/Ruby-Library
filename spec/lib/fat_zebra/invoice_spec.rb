require 'spec_helper'

describe FatZebra::Invoice do
  let(:invoice_csv_path) { "#{File.dirname(__FILE__)}/../../fixtures/invoice_test.csv" }

  let(:valid_create_payload) do
    {
      file:     File.new(invoice_csv_path),
      filename: 'invoices.csv',
    }
  end

  subject(:api_response) { make_request }

  describe '.create', :vcr do
    let(:make_request) { described_class.create(payload) }

    context "invalid payload" do
      let(:payload) { { } }

      it { expect { make_request }.to raise_exception(FatZebra::RequestError) }
    end

    context "valid payload" do
      let(:payload) { valid_create_payload }

      it { is_expected.to be_accepted }
      it { expect(api_response.status).to eq('pending') }
    end
  end

  describe '.find', :vcr do
    let(:make_request) { described_class.find(reference) }

    context "with a reference known to exist" do
      let(:reference) { 'abcd1234' }

      it { is_expected.to be_accepted }
      it { expect(api_response.amount).not_to be_nil }
      it { expect(api_response.reference).to eq(reference) }
    end

    context "with a reference known to not exist" do
      let(:reference) { SecureRandom.hex }

      it { expect { make_request }.to raise_exception(FatZebra::RequestError) }
    end
  end
end
