module BingAdsApi
  class AppAdExtension < BingAdsApi::AdExtension
    attr_accessor :app_platform,
                  :app_store_id,
                  :destination_url,
                  :device_preference,
                  :display_text

    def initialize(attributes = {})
      super({ device_preference: nil }.merge(attributes))
    end

    private

    def get_key_order
      super.concat(BingAdsApi::Config.instance.
        campaign_management_orders['app_ad_extension'])
    end
  end
end

