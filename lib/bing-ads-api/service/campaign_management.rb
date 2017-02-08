# -*- encoding : utf-8 -*-
module BingAdsApi


	# Public : This class represents the Campaign Management Services
	# defined in the Bing Ads API, to manage advertising campaigns
	#
	# Author:: jlopezn@neonline.cl
	#
	# Examples
	#  options = {
	#    :environment => :sandbox,
	#    :username => "username",
	#    :password => "pass",
	#    :developer_token => "SOME_TOKEN",
	#    :customer_id => "1234567",
	#    :account_id => "9876543" }
	#  service = BingAdsApi::CampaignManagement.new(options)
	class CampaignManagement < BingAdsApi::Service


		# Public : Constructor
		#
		# Author:: jlopezn@neonline.cl
		#
		# options - Hash with the parameters for the client proxy and the environment
		#
		# Examples
		#   options = {
		#     :environment => :sandbox,
		#     :username => "username",
		#     :password => "password",
		#     :developer_token => "DEV_TOKEN",
		#     :customer_id => "123456",
		#     :account_id => "654321"
		#   }
		#   service = BingAdsApi::CampaignManagement.new(options)
		def initialize(options={})
			super(options)
		end


		#########################
		## Operations Wrappers ##
		#########################

		# Public : Returns all the campaigns found in the specified account
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# account_id - account who owns the campaigns
		#
		# === Examples
		#   campaign_management_service.get_campaigns_by_account_id(1)
		#   # => Array[BingAdsApi::Campaign]
		#
		# Returns:: Array of BingAdsApi::Campaign
		#
		# Raises:: exception
		def get_campaigns_by_account_id(account_id)
			response = call(:get_campaigns_by_account_id,
				{account_id: account_id})
			response_hash = get_response_hash(response, __method__)
			response_campaigns = [response_hash[:campaigns][:campaign]].flatten.compact
			campaigns = response_campaigns.map do |camp_hash|
				BingAdsApi::Campaign.new(camp_hash)
			end
			return campaigns
		end


		# Public : Adds a campaign to the specified account
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# account_id - account who will own the newly campaigns
		# campaigns - An array of BingAdsApi::Campaign
		#
		# === Examples
		#   service.add_campaigns(1, [<BingAdsApi::Campaign>])
		#   # => <Hash>
		#
		# Returns:: hash with the 'add_campaigns_response' structure
		#
		# Raises:: exception
		def add_campaigns(account_id, campaigns)

			camps = []
			if campaigns.is_a? Array
				camps = campaigns.map{ |camp| camp.to_hash(:camelcase) }
			elsif campaigns.is_a? BingAdsApi::Campaign
				camps = campaigns.to_hash
			else
				raise "campaigns must be an array of BingAdsApi::Campaigns"
			end
			message = {
				:account_id => account_id,
				:campaigns => {:campaign => camps} }
			response = call(:add_campaigns, message)
			return get_response_hash(response, __method__)
		end


		# Public : Updates on or more campaigns for the specified account
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# account_id - account who own the updated campaigns
		# campaigns - Array with the campaigns to be updated
		#
		# === Examples
		#   service_update_campaigns(1, [<BingAdsApi::Campaign])
		#   # =>  true
		#
		# Returns:: boolean. true if the update was successful. false otherwise
		#
		# Raises:: exception
		def update_campaigns(account_id, campaigns)
			camps = []
			if campaigns.is_a? Array
				camps = campaigns.map do |camp|
					camp.to_hash(:camelcase)
				end
			elsif campaigns.is_a? BingAdsApi::Campaign
				camps = campaigns.to_hash
			else
				raise "campaigns must be an array of BingAdsApi::Campaigns"
			end
			message = {
				:account_id => account_id,
				:campaigns => {:campaign => camps} }
			response = call(:update_campaigns, message)
			return get_response_hash(response, __method__)

		end


		# Public : Delete one or more campaigns on the specified account
		#
		# Author:: alex.cavalli@offers.com
		#
		# === Parameters
		# account_id - account that owns the campaigns
		# campaign_ids - Array with the campaign IDs to be deleted
		#
		# === Examples
		#   service.delete_campaigns(1, [1,2,3])
		#   # =>  true
		#
		# Returns:: boolean. true if the delete was successful. false otherwise
		#
		# Raises:: exception
		def delete_campaigns(account_id, campaign_ids)
			message = {
				:account_id => account_id,
				:campaign_ids => {"ins1:long" => campaign_ids}
			}
			response = call(:delete_campaigns, message)
			return get_response_hash(response, __method__)
		end


		# Public : Returns all the ad groups that belongs to the
		# specified campaign
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# campaign_id   - campaign id
		#
		# === Examples
		#   service.get_ad_groups_by_campaign_id(1)
		#   # => Array[AdGroups]
		#
		# Returns:: Array with all the ad groups present in campaign_id
		#
		# Raises:: exception
		def get_ad_groups_by_campaign_id(campaign_id)
			response = call(:get_ad_groups_by_campaign_id,
				{campaign_id: campaign_id})
			response_hash = get_response_hash(response, __method__)
			response_ad_groups = [response_hash[:ad_groups][:ad_group]].flatten.compact
			ad_groups = response_ad_groups.map do |ad_group_hash|
				BingAdsApi::AdGroup.new(ad_group_hash)
			end
			return ad_groups
		end


		# Public : Returns the specified ad groups that belongs to the
		# specified campaign
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# campaign_id   - campaign id
		# ad_groups_ids - array with ids from ad groups
		#
		# === Examples
		#   service.get_ad_groups_by_ids(1, [1,2,3])
		#   # => Array[AdGroups]
		#
		# Returns:: Array with the ad groups specified in the ad_groups_ids array
		#
		# Raises:: exception
		def get_ad_groups_by_ids(campaign_id, ad_groups_ids)

			message = {
				:campaign_id => campaign_id,
				:ad_group_ids => {"ins1:long" => ad_groups_ids} }
			response = call(:get_ad_groups_by_ids, message)
			response_hash = get_response_hash(response, __method__)
			response_ad_groups = [response_hash[:ad_groups][:ad_group]].flatten
			ad_groups = response_ad_groups.map do |ad_group_hash|
				BingAdsApi::AdGroup.new(ad_group_hash)
			end
			return ad_groups

		end


		# Public : Adds 1 or more AdGroups to a Campaign
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# campaing_id - the campaign id where the ad groups will be added
		# ad_groups - Array[BingAdsApi::AdGroup] ad groups to be added
		#
		# === Examples
		#   service.add_ad_groups(1, [<BingAdsApi::AdGroup>])
		#   # => <Hash>
		#
		# Returns:: Hash with the 'add_ad_groups_response' structure
		#
		# Raises:: exception
		def add_ad_groups(campaign_id, ad_groups)

			groups = []
			if ad_groups.is_a? Array
				groups = ad_groups.map{ |gr| gr.to_hash(:camelcase) }
			elsif ad_groups.is_a? BingAdsApi::AdGroup
				groups = ad_groups.to_hash
			else
				raise "ad_groups must be an array of BingAdsApi::AdGroup"
			end
			message = {
				:campaign_id => campaign_id,
				:ad_groups => {:ad_group => groups} }
			response = call(:add_ad_groups, message)
			return get_response_hash(response, __method__)
		end


		# Public : Updates on or more ad groups in a specified campaign
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# campaign_id - campaign who owns the updated ad groups
		#
		# === Examples
		#   service.update_ad_groups(1, [<BingAdsApi::AdGroup])
		#   # => true
		#
		# Returns:: boolean. true if the updates is successfull. false otherwise
		#
		# Raises:: exception
		def update_ad_groups(campaign_id, ad_groups)
			groups = []
			if ad_groups.is_a? Array
				groups = ad_groups.map{ |gr| gr.to_hash(:camelcase) }
			elsif ad_groups.is_a? BingAdsApi::AdGroup
				groups = ad_groups.to_hash(:camelcase)
			else
				raise "ad_groups must be an array or instance of BingAdsApi::AdGroup"
			end
			message = {
				:campaign_id => campaign_id,
				:ad_groups => {:ad_group => groups} }
			response = call(:update_ad_groups, message)
			return get_response_hash(response, __method__)
		end


		# Public : Obtains all the ads associated to the specified ad group
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# ad_group_id - long with the ad group id
		#
		# === Examples
		#   service.get_ads_by_ad_group_id(1)
		#   # => [<BingAdsApi::Ad]
		#
		# Returns:: An array of BingAdsApi::Ad
		#
		# Raises:: exception
		def get_ads_by_ad_group_id(ad_group_id)
			response = call(:get_ads_by_ad_group_id,
				{ad_group_id: ad_group_id})
			response_hash = get_response_hash(response, __method__)
			response_ads = [response_hash[:ads][:ad]].flatten.compact
			ads = response_ads.map { |ad_hash| initialize_ad(ad_hash) }
			return ads
		end


		# Public : Obtains the ads indicated in ad_ids associated to the specified ad group
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# ad_group_id - long with the ad group id
		# ads_id - an Array io ads ids, that are associated to the ad_group_id provided
		#
		# === Examples
		#   service.get_ads_by_ids(1, [1,2,3])
		#   # => [<BingAdsApi::Ad>]
		#
		# Returns:: An array of BingAdsApi::Ad
		#
		# Raises:: exception
		def get_ads_by_ids(ad_group_id, ad_ids)


			message = {
				:ad_group_id => ad_group_id,
				:ad_ids => {"ins1:long" => ad_ids} }
			response = call(:get_ads_by_ids, message)
			response_hash = get_response_hash(response, __method__)

			if response_hash[:ads][:ad].is_a?(Array)
				ads = response_hash[:ads][:ad].map do |ad_hash|
					initialize_ad(ad_hash)
				end
			else
				ads = [ initialize_ad(response_hash[:ads][:ad]) ]
			end
			return ads
		end


		# Public : Add ads into a specified ad group
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# ad_group_id - a number with the id where the ads should be added
		# ads - an array of BingAdsApi::Ad instances
		#
		# === Examples
		#   # if the operation returns partial errors
		#   service.add_ads(1, [BingAdsApi::Ad])
		#   # => {:ad_ids => [], :partial_errors => BingAdsApi::PartialErrors }
		#
		#   # if the operation doesn't return partial errors
		#   service.add_ads(1, [BingAdsApi::Ad])
		#   # => {:ad_ids => [] }
		#
		# Returns:: Hash with the AddAdsResponse structure.
		# If the operation returns 'PartialErrors' key,
		# this methods returns those errors as an BingAdsApi::PartialErrors
		# instance
		#
		# Raises:: exception
		def add_ads(ad_group_id, ads)

			ads_for_soap = []
			if ads.is_a? Array
				ads_for_soap = ads.map{ |ad| ad.to_hash(:camelcase) }
			elsif ads.is_a? BingAdsApi::Ad
				ads_for_soap = ads.to_hash(:camelcase)
			else
				raise "ads must be an array or instance of BingAdsApi::Ad"
			end
			message = {
				:ad_group_id => ad_group_id,
				:ads => {:ad => ads_for_soap} }
			response = call(:add_ads, message)

			response_hash = get_response_hash(response, __method__)

			# Checks if there are partial errors in the request
			if response_hash[:partial_errors].key?(:batch_error)
				partial_errors = BingAdsApi::PartialErrors.new(
					response_hash[:partial_errors])
				response_hash[:partial_errors] = partial_errors
			else
				response_hash.delete(:partial_errors)
			end

			return response_hash
		end


		# Public : Updates ads for the specified ad group
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# ad_group_id - long with the ad group id
		# ads - array of BingAdsApi::Ad subclasses instances to update
		#
		# === Examples
		#   service.update_ads(1, [<BingAdsApi::Ad>])
		#   # => Hash
		#
		# Returns:: Hash with the UpdateAddsResponse structure
		#
		# Raises:: exception
		def update_ads(ad_group_id, ads)

			ads_for_soap = []
			if ads.is_a? Array
				ads_for_soap = ads.map{ |ad| ad.to_hash(:camelcase) }
			elsif ads.is_a? BingAdsApi::Ad
				ads_for_soap = ad.to_hash(:camelcase)
			else
				raise "ads must be an array or instance of BingAdsApi::Ad"
			end
			message = {
				:ad_group_id => ad_group_id,
				:ads => {:ad => ads_for_soap} }
			response = call(:update_ads, message)

			response_hash = get_response_hash(response, __method__)

			# Checks if there are partial errors in the request
			if response_hash[:partial_errors].key?(:batch_error)
				partial_errors = BingAdsApi::PartialErrors.new(
					response_hash[:partial_errors])
				response_hash[:partial_errors] = partial_errors
			else
				response_hash.delete(:partial_errors)
			end

			return response_hash
		end


		# Public: Obtains all the keywords associated to the specified ad group
		#
		# Author:: alex.cavalli@offers.com
		#
		# === Parameters
		# ad_group_id - long with the ad group id
		#
		# === Examples
		#   service.get_keywords_by_ad_group_id(1)
		#   # => [<BingAdsApi::Keyword]
		#
		# Returns:: An array of BingAdsApi::Keyword
		#
		# Raises:: exception
		def get_keywords_by_ad_group_id(ad_group_id)
			response = call(:get_keywords_by_ad_group_id,
				{ad_group_id: ad_group_id}
			)
			response_hash = get_response_hash(response, __method__)
			response_keywords = [response_hash[:keywords][:keyword]].flatten.compact
			keywords = response_keywords.map do |keyword_hash|
				BingAdsApi::Keyword.new(keyword_hash)
			end
			return keywords
		end


		# Public: Obtains the keywords indicated in keywords_ids associated with the specified ad group
		#
		# Author:: alex.cavalli@offers.com
		#
		# === Parameters
		# ad_group_id - long with the ad group id
		# keyword_ids - an Array of keyword ids that are associated with the ad_group_id provided
		#
		# === Examples
		#   service.get_keywords_by_ids(1, [1,2,3])
		#   # => [<BingAdsApi::Keyword>, <BingAdsApi::Keyword>, <BingAdsApi::Keyword>]
		#
		# Returns:: An array of BingAdsApi::Keyword
		#
		# Raises:: exception
		def get_keywords_by_ids(ad_group_id, keyword_ids)
			message = {
				:ad_group_id => ad_group_id,
				:keyword_ids => {"ins1:long" => keyword_ids} }
			response = call(:get_keywords_by_ids, message)
			response_hash = get_response_hash(response, __method__)
			response_keywords = [response_hash[:keywords][:keyword]].flatten
			keywords = response_keywords.map do |keyword_hash|
				BingAdsApi::Keyword.new(keyword_hash)
			end
			return keywords
		end


		# Public: Add keywords into a specified ad group
		#
		# Author:: alex.cavalli@offers.com
		#
		# === Parameters
		# ad_group_id - id of the ad group to add keywords to
		# keywords - an array of BingAdsApi::Keyword instances
		#
		# === Examples
		#   # if the operation returns partial errors
		#   service.add_keywords(1, [BingAdsApi::Keyword])
		#   # => {:keyword_ids => [], :partial_errors => BingAdsApi::PartialErrors }
		#
		#   # if the operation doesn't return partial errors
		#   service.add_keywords(1, [BingAdsApi::Keyword])
		#   # => {:keyword_ids => [] }
		#
		# Returns:: Hash with the AddKeywordsResponse structure.
		# If the operation returns 'PartialErrors' key,
		# this methods returns those errors as an BingAdsApi::PartialErrors
		# instance
		#
		# Raises:: exception
		def add_keywords(ad_group_id, keywords)
			keywords_for_soap = []
			if keywords.is_a? Array
				keywords_for_soap = keywords.map{ |keyword| keyword.to_hash(:camelcase) }
			elsif keywords.is_a? BingAdsApi::Keyword
				keywords_for_soap = keywords.to_hash(:camelcase)
			else
				raise "keywords must be an array or instance of BingAdsApi::Keyword"
			end
			message = {
				:ad_group_id => ad_group_id,
				:keywords => {:keyword => keywords_for_soap} }
			response = call(:add_keywords, message)

			response_hash = get_response_hash(response, __method__)

			# Checks if there are partial errors in the request
			if response_hash[:partial_errors].key?(:batch_error)
				partial_errors = BingAdsApi::PartialErrors.new(
					response_hash[:partial_errors])
				response_hash[:partial_errors] = partial_errors
			else
				response_hash.delete(:partial_errors)
			end

			return response_hash
		end


		# Public: Updates keywords for the specified ad group
		#
		# Author:: alex.cavalli@offers.com
		#
		# === Parameters
		# ad_group_id - long with the ad group id
		# keywords - array of BingAdsApi::Keyword instances to update
		#
		# === Examples
		#   service.update_keywords(1, [<BingAdsApi::Keyword>])
		#   # => Hash
		#
		# Returns:: Hash with the UpdateKeywordsResponse structure
		#
		# Raises:: exception
		def update_keywords(ad_group_id, keywords)
			keywords_for_soap = []
			if keywords.is_a? Array
				keywords_for_soap = keywords.map{ |keyword| keyword.to_hash(:camelcase) }
			elsif keywords.is_a? BingAdsApi::Keyword
				keywords_for_soap = keyword.to_hash(:camelcase)
			else
				raise "keywords must be an array or instance of BingAdsApi::Keyword"
			end
			message = {
				:ad_group_id => ad_group_id,
				:keywords => {:keyword => keywords_for_soap} }
			response = call(:update_keywords, message)

			response_hash = get_response_hash(response, __method__)

			# Checks if there are partial errors in the request
			if response_hash[:partial_errors].key?(:batch_error)
				partial_errors = BingAdsApi::PartialErrors.new(
					response_hash[:partial_errors])
				response_hash[:partial_errors] = partial_errors
			else
				response_hash.delete(:partial_errors)
			end

			return response_hash
		end

		# Public : Adds one or more ad extensions to an account’s ad extension library.
		#
		# Author:: ricky@tenjin.io
		#
		# === Parameters
		# account_id - The identifier of the account to add the extensions to.
		# ad_extensions - Array[BingAdsApi::AdExtension] The array of ad extensions of any type to add to the account.
		#
		# === Examples
		#   service.add_ad_extensions(1, [<BingAdsApi::AdExtensions>])
		#   # => <Array>
		#
		# Returns:: Array of AdExtension ids
		#
		# Raises:: exception
		def add_ad_extensions(account_id, ad_extensions)
			exts = ad_extensions.map{ |gr| gr.to_hash(:camelcase) }
			message = {
					:account_id => account_id,
					:ad_extensions => {:ad_extension => exts} }
			response = call(:add_ad_extensions, message)
			response_hash = get_response_hash(response, __method__)
			identities = response_hash[:ad_extension_identities][:ad_extension_identity]
			if identities.is_a? Array
				identities.map { |d| d[:id] }
			elsif identities.is_a? Hash
				[ identities[:id] ]
			end
		end

		# Public : Gets the ad extensions from the account’s ad extension library.
		#
		# Author:: ricky@tenjin.io
		#
		# === Parameters
		# account_id - The identifier of the account that contains the ad extensions to get.
		#
		# === Examples
		#   campaign_management_service.get_ad_extensions_by_account_id(1, BingAdsApi::AdExtensionType::APP_AD_EXTENSION)
		#   # => Array[int]
		#
		# Returns:: Array of AdExtension ids
		#
		# Raises:: exception
		def get_ad_extension_ids_by_account_id(account_id, ad_extension_type, association_type = nil)
			response = call(:get_ad_extension_ids_by_account_id,
											{ account_id: account_id,
												ad_extension_type: ad_extension_type,
												association_type: association_type
											})
			response_hash = get_response_hash(response, __method__)
			ids = response_hash[:ad_extension_ids][:long]
			case ids
				when String
					[ids]
				when nil
					[]
				else
					ids
			end
		end

		# Public : Gets the specified ad extensions from the account’s ad extension library.
		#
		# === Parameters
		# account_id - The identifier of the account that owns the ad extensions.
		# ad_extension_ids - An array of ad extension identifiers.
		# ad_extension_type - The types of ad extensions that the list of identifiers contains.
		#
		# === Examples
		#   campaign_management_service.get_ad_extensions_by_ids(1, [1,2,3], BingAdsApi::AdExtensionType::APP_AD_EXTENSION)
		#   # => Array[BingAdsApi::AppAdExtension]
		#
		# Returns:: Array of BingAdsApi::AdExtension
		#
		# Raises:: exception
		def get_ad_extensions_by_ids(account_id, ad_extension_ids, ad_extension_type)
			response = call(:get_ad_extensions_by_ids,
											{ account_id: account_id,
												ad_extension_ids: { "ins1:long" => ad_extension_ids },
												ad_extension_type: ad_extension_type
											})
			response_hash = get_response_hash(response, __method__)
			response_hash[:ad_extensions][:ad_extension].map do |info|
				initialize_ad_extension(info)
			end
		end

		def delete_ad_extensions(account_id, ad_extension_ids)
			response = call(:delete_ad_extensions,
											{ account_id: account_id,
											ad_extension_ids: { "ins1:long" => ad_extension_ids }})
			get_response_hash(response, __method__)
		end

		private
			def get_service_name
				"campaign_management"
			end

			# Private : Returns an instance of any of the subclases of BingAdsApi::Ad based on the '@i:type' value in the hash
			#
			# Author:: jlopezn@neonline.cl
			#
			# ad_hash - Hash returned by the SOAP request with the Ad attributes
			#
			# Examples
			#   initialize_ad({:device_preference=>"0", :editorial_status=>"Active",
			#      :forward_compatibility_map=>{:"@xmlns:a"=>"http://schemas.datacontract.org/2004/07/System.Collections.Generic"},
			#      :id=>"1", :status=>"Active", :type=>"Text",
			#      :destination_url=>"www.some-url.com", :display_url=>"http://www.some-url.com",
			#      :text=>"My Page", :title=>"My Page",
			#      :"@i:type"=>"TextAd"})
			#   # => BingAdsApi::TextAd
			#
			# Returns:: BingAdsApi::Ad subclass instance
			def initialize_ad(ad_hash)
				ad = BingAdsApi::Ad.new(ad_hash)
				case ad_hash["@i:type".to_sym]
				when "TextAd"
					ad = BingAdsApi::TextAd.new(ad_hash)
				when "MobileAd"
					ad = BingAdsApi::MobileAd.new(ad_hash)
				when "ProductAd"
					ad = BingAdsApi::ProductAd.new(ad_hash)
				end
				return ad
			end

			def initialize_ad_extension(ad_extension_hash)
				case ad_extension_hash[:'@i:type']
					when 'AppAdExtension'
						BingAdsApi::AppAdExtension.new(ad_extension_hash)
					else
						BingAdsApi::AdExtension.new(ad_extension_hash)
				end
			end
	end

end
