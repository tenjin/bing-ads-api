# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::Reporting do

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
	let(:service) { BingAdsApi::Reporting.new(default_options) }

	it "should initialize with options" do
		new_service = BingAdsApi::Reporting.new(default_options)
		expect(new_service).not_to be_nil
	end

	it "should submit campaign performance report" do
		campaign_id = BingAdsFactory.create_campaign
		report_request = BingAdsApi::CampaignPerformanceReportRequest.new(
			:format => :xml,
			:language => :english,
			:report_name => "My Report",
			:aggregation => :hourly,
			:columns => [
				:account_name, :account_number, :time_period,
				:campaign_name, :campaign_id, :status, :currency_code,
				:impressions, :clicks, :ctr, :average_cpc, :spend,
				:conversions, :conversion_rate, :cost_per_conversion
			],
			:filter => {
				# String as bing expected
				:ad_distribution => "Search",
				:device_os => "Windows",
				# snake case symbol
				:device_type => :computer,
				# nil criteria
				:status => nil
			},
			:scope => {
				:account_ids => default_options[:account_id],
				:campaigns => [
					{:account_id => default_options[:account_id], :campaign_id => campaign_id}
				]
			},
			:time => {
				:custom_date_range_end => {:day => 31, :month => 12, :year => 2013},
				:custom_date_range_start => {:day => 1, :month => 12, :year => 2013},
			}
		)

		report_request_id = nil
		expect{
			report_request_id = service.submit_generate_report(report_request)
		}.not_to raise_error

		expect(report_request_id).not_to be_nil
	end

	it "should submit keyword performance report" do
		campaign_id = BingAdsFactory.create_campaign
		report_request = BingAdsApi::KeywordPerformanceReportRequest.new(
      :format   => :xml,
      :language => :english,
      :report_name => "Me report",
      :aggregation => :hourly,
      :columns => [:account_name, :account_number, :time_period, :keyword, :spend],
      # The filter is specified as a hash
      :filter => {
        # specifies the Bing expected String value
        :ad_distribution => "Search",
        :ad_type => "Text",
        :bid_match_type => "Exact",
        :delivered_match_type => "Exact",
        # specifies criteria as a snake case symbol
        :device_type => :tablet,
        :keyword_relevance => [3],
        :landing_page_relevance => [2],
        :landing_page_user_experience => [2],
        :language_code => ["EN"],
        :quality_score => [7,8,9,10] },
      :max_rows => 10,
      :scope => {
        :account_ids => default_options[:account_id],
				:campaigns => []
			},
      # predefined date
      :time => :this_week
		)

		report_request_id = nil
		expect{
			report_request_id = service.submit_generate_report(report_request)
		}.not_to raise_error

		expect(report_request_id).not_to be_nil
	end

	it "should submit account performance report" do
		report_request = BingAdsApi::AccountPerformanceReportRequest.new(
			:format => :xml,
			:language => :english,
			:report_name => "My Report",
			:aggregation => :hourly,
			:columns => [
				:account_name, :account_number, :time_period,
				:currency_code, :impressions, :clicks, :ctr, :average_cpc,
				:spend, :conversions, :cost_per_conversion
			],
			:filter => {
				# String as bing expected
				:ad_distribution => "Search",
				# snake case symbol
				:device_os => :windows,
				# nil criteria
				:device_type => nil
			},
			:scope => {:account_ids => default_options[:account_id] },
			:time => {
				:custom_date_range_end => {:day => 31, :month => 12, :year => 2013},
				:custom_date_range_start => {:day => 1, :month => 12, :year => 2013},
			}
		)

		report_request_id = nil
		expect{
			report_request_id = service.submit_generate_report(report_request)
		}.not_to raise_error

		expect(report_request_id).not_to be_nil
	end

	it "should initialize report request status" do
		report_request_status = BingAdsApi::ReportRequestStatus.new(
			:report_download_url => "http://some.url.com",
			:status => "Success"
		)
		expect(report_request_status).not_to be_nil
	end

	context "when a report has been requested" do

		before :each do
			report_request = BingAdsApi::AccountPerformanceReportRequest.new(
				:format => :xml,
				:language => :english,
				:report_name => "My Report",
				:aggregation => :hourly,
				:columns => [
					:account_name, :account_number, :time_period,
					:currency_code, :impressions, :clicks, :ctr, :average_cpc,
					:spend, :conversions, :cost_per_conversion
				],
				:filter => {
					# String as bing expected
					:ad_distribution => "Search",
					# snake case symbol
					:device_os => :windows,
					# nil criteria
					:device_type => nil
				},
				:scope => {:account_ids => default_options[:account_id] },
				:time => {
					:custom_date_range_end => {:day => 31, :month => 12, :year => 2013},
					:custom_date_range_start => {:day => 1, :month => 12, :year => 2013},
				}
			)

			@report_request_id = service.submit_generate_report(report_request)
		end

		it "should successfully poll generate report" do
			report_request_status = nil
			expect{
				report_request_status = service.poll_generate_report(@report_request_id)
			}.not_to raise_error

			expect(report_request_status).not_to be_nil

			expect(report_request_status.error?).to eq(false)
		end

	end
end
