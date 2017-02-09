# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'httplog'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::CampaignManagement do

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
	let(:service) { BingAdsApi::CampaignManagement.new(default_options) }

	it "should initialize with options" do
		new_service = BingAdsApi::CampaignManagement.new(default_options)
		expect(new_service).not_to be_nil
	end

	describe "campaign operations" do

		it "should add a campaign" do
			name = "Test Campaign #{SecureRandom.uuid}"
			campaigns = [
				BingAdsApi::Campaign.new(
					budget_type: BingAdsApi::Campaign::DAILY_BUDGET_STANDARD,
					daily_budget: 2000,
					daylight_saving: "false",
					description: name + " description",
					name: name + " name",
					time_zone: BingAdsApi::Campaign::SANTIAGO
				)
			]
			response = service.add_campaigns(default_options[:account_id], campaigns)

			expect(response[:campaign_ids][:long]).not_to be_nil
		end

		it "should get campaigns by account when there are no campaigns" do
			# clean all campaigns first
	    campaign_ids = service.get_campaigns_by_account_id(default_options[:account_id]).map(&:id)
	    campaign_ids.each_slice(100) do |ids|
	      service.delete_campaigns(default_options[:account_id], ids)
	    end

			response = service.get_campaigns_by_account_id(default_options[:account_id])
			expect(response).to be_kind_of(Array)
			expect(response).to be_empty
		end

		context "when a campaign has already been created" do

			before :each do
				@campaign_id = BingAdsFactory.create_campaign
			end

			it "should get campaigns by account when there's only one campaign" do
				response = service.get_campaigns_by_account_id(default_options[:account_id])
				expect(response).not_to be_nil
				expect(response).to be_kind_of(Array)
			end

			it "should get campaigns by account when there are multiple campaigns" do
				BingAdsFactory.create_campaign
				response = service.get_campaigns_by_account_id(default_options[:account_id])
				expect(response).not_to be_nil
				expect(response).to be_kind_of(Array)
			end

			it "should update campaigns" do
				name = "Test Campaign Update #{SecureRandom.uuid}"
				campaigns = [
					BingAdsApi::Campaign.new(
						id: @campaign_id,
						budget_type: BingAdsApi::Campaign::DAILY_BUDGET_STANDARD,
						daily_budget: 2000,
						daylight_saving: "false",
						description: name + " description",
						name: name + " name",
						time_zone: BingAdsApi::Campaign::SANTIAGO
					)
				]

				response = service.update_campaigns(default_options[:account_id], campaigns)

				expect(response).not_to be_nil
			end

			it "should delete campaigns" do
				campaign_ids = [@campaign_id]

				response = service.delete_campaigns(default_options[:account_id], campaign_ids)

				expect(response).not_to be_nil
			end

		end
	end

	describe "ad group operations" do

		before :each do
			@campaign_id = BingAdsFactory.create_campaign
		end

		it "should add an ad group" do
			name = "Ad Group #{SecureRandom.uuid}"
			ad_groups = [
				BingAdsApi::AdGroup.new(
					ad_distribution: BingAdsApi::AdGroup::SEARCH,
					language: BingAdsApi::AdGroup::SPANISH,
					name: name + " name",
					pricing_model: BingAdsApi::AdGroup::CPC,
					bidding_model: BingAdsApi::AdGroup::KEYWORD
				)
			]
			response = service.add_ad_groups(@campaign_id, ad_groups)

			expect(response[:ad_group_ids][:long]).not_to be_nil
		end

		it "should get ad groups by campaign when there are no ad groups" do
			response = service.get_ad_groups_by_campaign_id(@campaign_id)
			expect(response).to be_kind_of(Array)
			expect(response).to be_empty
		end

		context "when an ad group has already been created" do

			before :each do
			  @ad_group_id = BingAdsFactory.create_ad_group(@campaign_id)
			end

			it "should get ad groups by campaign when there's only one ad group" do
				response = service.get_ad_groups_by_campaign_id(@campaign_id)

				expect(response).not_to be_empty
				expect(response).to be_kind_of(Array)
			end

			it "should get ad groups by campaign when there are multiple ad groups" do
				BingAdsFactory.create_ad_group(@campaign_id)
				response = service.get_ad_groups_by_campaign_id(@campaign_id)

				expect(response).not_to be_empty
				expect(response).to be_kind_of(Array)
			end

			it "should get ad groups by ids when there's only one ad group" do
				response = service.get_ad_groups_by_ids(@campaign_id, [@ad_group_id])

				expect(response).not_to be_nil
				expect(response.size).to eq(1)
			end

			it "should get ad groups by ids when there are multiple ad groups" do
				ad_group_id_2 = BingAdsFactory.create_ad_group(@campaign_id)
				response = service.get_ad_groups_by_ids(@campaign_id, [@ad_group_id, ad_group_id_2])

				expect(response).not_to be_nil
				expect(response.size).to eq(2)
			end

			it "should update ad groups" do
				name = "Test Ad Group Update #{SecureRandom.uuid}"
				ad_groups = [
					BingAdsApi::AdGroup.new(
						id: @ad_group_id,
						name: name
					)
				]

				response = service.update_ad_groups(@campaign_id, ad_groups)
			end

		end
	end

	describe "ad operations" do

		before :each do
			campaign_id = BingAdsFactory.create_campaign
			@ad_group_id = BingAdsFactory.create_ad_group(campaign_id)
		end

		describe "text ads" do

			it "should add a single ad" do
				text_ad = BingAdsApi::TextAd.new(
					status: BingAdsApi::Ad::ACTIVE,
					destination_url: "http://www.adxion.com",
					display_url: "AdXion.com",
					text: "Text Ad #{SecureRandom.uuid}",
					title: "Text Ad"
				)

				response = service.add_ads(@ad_group_id, text_ad)
				expect(response).not_to be_nil
				expect(response[:partial_errors]).to be_nil
				expect(response[:ad_ids][:long]).not_to be_nil
			end

			it "should add multiple ads" do
				text_ads = [
					BingAdsApi::TextAd.new(
						status: BingAdsApi::Ad::ACTIVE,
						destination_url: "http://www.adxion.com",
						display_url: "AdXion.com",
						text: "TextAd #{SecureRandom.uuid}",
						title: "TextAd"
					),
					BingAdsApi::TextAd.new(
						status: BingAdsApi::Ad::ACTIVE,
						destination_url: "http://www.adxion.com",
						display_url: "AdXion.com",
						text: "TextAd 2 #{SecureRandom.uuid}",
						title: "TextAd 2"
					)
				]

				response = service.add_ads(@ad_group_id, text_ads)
				expect(response).not_to be_nil
				expect(response[:partial_errors]).to be_nil
				expect(response[:ad_ids][:long]).not_to be_nil
			end

		end

		it "should add an ad with partial errors" do
			text_ad = BingAdsApi::TextAd.new(
				status: BingAdsApi::Ad::INACTIVE,
				destination_url: "http://www.adxion.com",
				display_url: "http://www.adxion.com",
				text: "Text Ad #{SecureRandom.uuid}",
				title: "Text Ad #{SecureRandom.uuid}"
			)

			response = service.add_ads(@ad_group_id, text_ad)
			expect(response).not_to be_nil
			expect(response[:partial_errors]).not_to be_nil
		end

		it "should get ads by ad group id when there are no ads" do
			ads = service.get_ads_by_ad_group_id(@ad_group_id)
			expect(ads).to be_empty
		end

		context "when an ad has already been created" do

			before :each do
			  @ad_id = BingAdsFactory.create_text_ad(@ad_group_id)
			end

			it "should get ads by ad group id when there's only one ad" do
				ads = service.get_ads_by_ad_group_id(@ad_group_id)
				expect(ads).not_to be_empty
				ad = ads.first
				expect(ad).to be_kind_of(BingAdsApi::Ad)
			end

			it "should get ads by ad group id when there are multiple ads" do
				BingAdsFactory.create_text_ad(@ad_group_id)
				ads = service.get_ads_by_ad_group_id(@ad_group_id)
				expect(ads).not_to be_empty
				ads.each do |ad|
					expect(ad).to be_kind_of(BingAdsApi::Ad)
				end
			end

			it "should get ads by ids when there's only one ad" do
				ads_by_ids = service.get_ads_by_ids(@ad_group_id, [@ad_id])
				expect(ads_by_ids).not_to be_nil
				expect(ads_by_ids.size).to eq(1)
			end

			it "should get ads by ids when there are multiple ads" do
				ad_id_2 = BingAdsFactory.create_text_ad(@ad_group_id)
				ads_by_ids = service.get_ads_by_ids(@ad_group_id, [@ad_id, ad_id_2])
				expect(ads_by_ids).not_to be_nil
				expect(ads_by_ids.size).to eq(2)
				ads_by_ids.each do |ad|
					expect(ad).to be_kind_of(BingAdsApi::Ad)
				end
			end

			it "should update ads" do
				text_ad = BingAdsApi::TextAd.new(
					id: @ad_id,
					status: BingAdsApi::Ad::ACTIVE,
					destination_url: "http://www.adxion.com",
					display_url: "http://www.adxion.com",
					text: "Ad #{SecureRandom.uuid}",
					title: "Title"
				)

				response = service.update_ads(@ad_group_id, [text_ad])
				expect(response).not_to be_nil
				expect(response[:partial_errors]).to be_nil
			end

		end
	end

	describe "keyword operations" do

		before :each do
			campaign_id = BingAdsFactory.create_campaign
			@ad_group_id = BingAdsFactory.create_ad_group(campaign_id)
		end

		it "should add a single keyword" do
			keyword = BingAdsApi::Keyword.new(
				bid: BingAdsApi::Bid.new(amount: 1.23),
				destination_url: "http://www.adxion.com",
				match_type: BingAdsApi::Keyword::EXACT,
				status: BingAdsApi::Keyword::ACTIVE,
				text: "Keyword #{SecureRandom.uuid}"
			)

			response = service.add_keywords(@ad_group_id, keyword)
			expect(response).not_to be_nil
			expect(response[:partial_errors]).to be_nil
			expect(response[:keyword_ids][:long]).not_to be_nil
		end

		it "should add multiple keywords" do
			keywords = [
				BingAdsApi::Keyword.new(
					bid: BingAdsApi::Bid.new(amount: 1.23),
					destination_url: "http://www.adxion.com",
					match_type: BingAdsApi::Keyword::EXACT,
					status: BingAdsApi::Keyword::ACTIVE,
					text: "Keyword #{SecureRandom.uuid}"
				),
				BingAdsApi::Keyword.new(
					bid: BingAdsApi::Bid.new(amount: 1.23),
					destination_url: "http://www.adxion.com",
					match_type: BingAdsApi::Keyword::EXACT,
					status: BingAdsApi::Keyword::ACTIVE,
					text: "Keyword #{SecureRandom.uuid}"
				)
			]

			response = service.add_keywords(@ad_group_id, keywords)
			expect(response).not_to be_nil
			expect(response[:partial_errors]).to be_nil
			expect(response[:keyword_ids][:long]).not_to be_nil
		end

		it "should add a keyword with partial errors" do
			keyword = BingAdsApi::Keyword.new(
        # missing bid
				destination_url: "http://www.bing.com/",
				match_type: BingAdsApi::Keyword::EXACT,
				status: BingAdsApi::Keyword::ACTIVE,
				text: "Keyword #{SecureRandom.uuid}"
			)

			response = service.add_keywords(@ad_group_id, keyword)
			expect(response).not_to be_nil
			expect(response[:partial_errors]).not_to be_nil
		end

		it "should get keywords by ad group id when there are no keywords" do
			keywords = service.get_keywords_by_ad_group_id(@ad_group_id)
			expect(keywords).to be_empty
		end

		context "when a keyword has already been created" do

			before :each do
			  @keyword_id = BingAdsFactory.create_keyword(@ad_group_id)
			end

			it "should get keywords by ad group id when there's only one keyword" do
				keywords = service.get_keywords_by_ad_group_id(@ad_group_id)
				expect(keywords).not_to be_empty
				keyword = keywords.first
				expect(keyword).to be_kind_of(BingAdsApi::Keyword)
			end

			it "should get keywords by ad group id when there are multiple keywords" do
				BingAdsFactory.create_keyword(@ad_group_id)
				keywords = service.get_keywords_by_ad_group_id(@ad_group_id)
				expect(keywords).not_to be_empty
				keywords.each do |keyword|
					expect(keyword).to be_kind_of(BingAdsApi::Keyword)
				end
			end

			it "should get keywords by ids when there's only one keyword" do
				keywords_by_ids = service.get_keywords_by_ids(@ad_group_id, [@keyword_id])
				expect(keywords_by_ids).not_to be_nil
				expect(keywords_by_ids.size).to eq(1)
			end

			it "should get keywords by ids when there are multiple keywords" do
				keyword_id_2 = BingAdsFactory.create_keyword(@ad_group_id)
				keywords_by_ids = service.get_keywords_by_ids(@ad_group_id, [@keyword_id, keyword_id_2])
				expect(keywords_by_ids).not_to be_nil
				expect(keywords_by_ids.size).to eq(2)
				keywords_by_ids.each do |keyword|
					expect(keyword).to be_kind_of(BingAdsApi::Keyword)
				end
			end

			it "should update keywords" do
				keyword = BingAdsApi::Keyword.new(
					id: @keyword_id,
					bid: BingAdsApi::Bid.new(amount: 99.99)
				)

				response = service.update_keywords(@ad_group_id, [keyword])
				expect(response).not_to be_nil
				expect(response[:partial_errors]).to be_nil
			end

		end
	end

	describe "ad extension operations" do
		before :each do
			ids = service.get_ad_extension_ids_by_account_id(
					default_options[:account_id],
					BingAdsApi::AdExtensionType::APP_AD_EXTENSION)
			unless ids.empty?
				service.delete_ad_extensions(default_options[:account_id], ids)
			end
		end

		it "should add one ad extension" do
			ids = BingAdsFactory.create_app_ad_extension
			expect(ids.size).to eq 1
		end

		it "should add multiple ad extension" do
			ids = BingAdsFactory.create_app_ad_extension(3)
			expect(ids.size).to eq 3
		end

		it "should get ad extension ids by account id" do
			ids_created = BingAdsFactory.create_app_ad_extension
			ids_get = service.get_ad_extension_ids_by_account_id(
					default_options[:account_id],
					BingAdsApi::AdExtensionType::APP_AD_EXTENSION)
			expect(ids_get.size).to eq 1
			expect(ids_get).to eq ids_created
		end

		it "should get ad extension ids by account id with association type" do
			ids = service.get_ad_extension_ids_by_account_id(
					default_options[:account_id],
					BingAdsApi::AdExtensionType::APP_AD_EXTENSION,
					BingAdsApi::AssociationType::AD_GROUP
			)
			expect(ids).to be_empty
		end

		it "should get ad extensions by ids" do
			ids = BingAdsFactory.create_app_ad_extension 2
			exts = service.get_ad_extensions_by_ids(
					default_options[:account_id],
					ids,
					BingAdsApi::AdExtensionType::APP_AD_EXTENSION)
			expect(exts.size).to eq 2
			expect(exts[0]).to be_a BingAdsApi::AdExtension
			expect(exts[0]).to be_a BingAdsApi::AppAdExtension
    end

    it "should delete ad extensions" do
			ids = BingAdsFactory.create_app_ad_extension
			service.delete_ad_extensions(default_options[:account_id], ids)
			sleep 1
			ids = service.get_ad_extension_ids_by_account_id(
					default_options[:account_id],
					BingAdsApi::AdExtensionType::APP_AD_EXTENSION)
			expect(ids).to be_empty
    end

    context "ad extension associations" do
      let(:extension_id) {
        BingAdsFactory.create_app_ad_extension.first
      }
      let(:campaign_id) {
				BingAdsFactory.create_campaign
      }
      let(:ad_group_id) {
			  BingAdsFactory.create_ad_group(campaign_id)
      }

      it "should set ad extension association" do
        exts = service.set_ad_extensions_associations(default_options[:account_id],
                                                      BingAdsApi::AssociationType::AD_GROUP,
                                                      [ [ extension_id, ad_group_id ] ])
        expect(exts).to_not be_nil
      end

      it "should get ad extension associations for one entity" do
        service.set_ad_extensions_associations(default_options[:account_id],
                                               BingAdsApi::AssociationType::AD_GROUP,
                                               [ [ extension_id, ad_group_id ] ])
        result = service.get_ad_extensions_associations(
            default_options[:account_id],
            BingAdsApi::AdExtensionType::APP_AD_EXTENSION,
            BingAdsApi::AssociationType::AD_GROUP,
            [ ad_group_id ])

        expect(result.size).to eq 1
				expect(result.first).to be_a(Array)
				expect(result.first.size).to eq 1
				expect(result.first.first).to be_a(BingAdsApi::AdExtensionAssociation)
				expect(result.first.first.ad_extension).to be_a(BingAdsApi::AdExtension)
				expect(result.first.first.ad_extension.id).to eq extension_id
      end

			it "should get ad extension associations for multiple entities" do
				service.set_ad_extensions_associations(default_options[:account_id],
																							 BingAdsApi::AssociationType::AD_GROUP,
																							 [ [ extension_id, ad_group_id ] ])
				result = service.get_ad_extensions_associations(
						default_options[:account_id],
						BingAdsApi::AdExtensionType::APP_AD_EXTENSION,
						BingAdsApi::AssociationType::AD_GROUP,
						[ ad_group_id, 999 ])

				expect(result.size).to eq 2
				expect(result.first).to be_a(Array)
				expect(result.first.size).to eq 1
				expect(result.first.first).to be_a(BingAdsApi::AdExtensionAssociation)
				expect(result.first.first.ad_extension).to be_a(BingAdsApi::AdExtension)
				expect(result.first.first.ad_extension.id).to eq extension_id
				expect(result.last).to be_nil
			end
    end


	end
end
