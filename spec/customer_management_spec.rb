# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::CustomerManagement do

	let(:default_options) do
		{
			environment: :sandbox,
			username: "ruby_bing_ads_sbx",
			password: "sandbox123",
			developer_token: "BBD37VB98",
			customer_id: "21025739",
			account_id: "8506945"
		}
	end
	let(:service) { BingAdsApi::CustomerManagement.new(default_options) }

	it "should initialize with options" do
		new_service = BingAdsApi::CustomerManagement.new(default_options)
		expect(new_service).not_to be_nil
	end

	it "should get accounts info" do
		response = service.get_accounts_info
		expect(response).not_to be_nil
		expect(response).to be_kind_of(Array)
	end

	it "should find accounts or customers info" do
		response = service.find_accounts_or_customers_info
		expect(response).not_to be_nil
		expect(response).to be_kind_of(Array)
		expect(response.size).to eq 1
		expect(response[0].customer_id).to eq default_options[:customer_id]
		expect(response[0].account_id).to eq default_options[:account_id]
	end

	it "should find accounts or customers info, with nils" do
		response = service.find_accounts_or_customers_info(nil, 1, nil)
		expect(response).not_to be_nil
		expect(response).to be_kind_of(Array)
		expect(response.size).to eq 1
		expect(response[0].customer_id).to eq default_options[:customer_id]
		expect(response[0].account_id).to eq default_options[:account_id]
	end

end
