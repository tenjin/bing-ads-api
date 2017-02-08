class BingAdsFactory

  # Helper method to create a campaign on the remote API. Returns the created
  # campaign id.
  def self.create_campaign
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
    response = service.add_campaigns(account_id, campaigns)
    response[:campaign_ids][:long]
  end

  # Helper method to create an ad group on the remote API. Returns the created
  # ad group id.
  def self.create_ad_group(campaign_id)
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
    response = service.add_ad_groups(campaign_id, ad_groups)
    response[:ad_group_ids][:long]
  end

  def self.create_app_ad_extension(size=1)
    ad_extensions = []
    size.times do |i|
      ad_extensions << BingAdsApi::AppAdExtension.new(
          app_platform: 'iOS',
          app_store_id: (12345678 + i).to_s,
          destination_url: "https://track.domain.com/trackingid#{i}",
          display_text: "my ios app tracking link #{i}")
    end
    service.add_ad_extensions(account_id, ad_extensions)
  end

  # Helper method to create an ad on the remote API. Returns the created ad id.
  def self.create_text_ad(ad_group_id)
    text_ad = BingAdsApi::TextAd.new(
      status: BingAdsApi::Ad::ACTIVE,
      destination_url: "http://www.adxion.com",
      display_url: "AdXion.com",
      text: "Text Ad #{SecureRandom.uuid}",
      title: "Text Ad"
    )
    response = service.add_ads(ad_group_id, text_ad)
    response[:ad_ids][:long]
  end

  # Helper method to create a keyword on the remote API. Returns the created
  # keyword id.
  def self.create_keyword(ad_group_id)
    keyword = BingAdsApi::Keyword.new(
      bid: BingAdsApi::Bid.new(amount: 1.23),
      destination_url: "http://www.adxion.com",
      match_type: BingAdsApi::Keyword::EXACT,
      status: BingAdsApi::Keyword::ACTIVE,
      text: "Keyword #{SecureRandom.uuid}"
    )
    response = service.add_keywords(ad_group_id, keyword)
    response[:keyword_ids][:long]
  end

  def self.service
    @service ||= BingAdsApi::CampaignManagement.new(
      environment: :sandbox,
      username: "ruby_bing_ads_sbx",
      password: "sandbox123",
      developer_token: "BBD37VB98",
      customer_id: "21025739",
      account_id: account_id
    )
  end

  def self.account_id
    "8506945"
  end

end
