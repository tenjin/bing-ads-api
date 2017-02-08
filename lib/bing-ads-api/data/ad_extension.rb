module BingAdsApi
  class AdExtension < BingAdsApi::DataObject
    include BingAdsApi::AdExtensionStatus
    include BingAdsApi::AdExtensionType

    attr_accessor :forward_compatibility_map,
                  :id,
                  :scheduling,
                  :status,
                  :type,
                  :version

    def initialize(attributes={})
      super({ id: nil,
              status: nil,
              type: nil
            }.merge(attributes))
    end

    def to_hash(keys=:underscore)
      hash = super(keys)
      hash[:'@xsi:type'] = "#{ClientProxy::NAMESPACE}:#{self.class.name.split('::').last}"
      hash
    end

    private

    def get_key_order
      super.concat(BingAdsApi::Config.instance.
        campaign_management_orders['ad_extension'])
    end
  end
end

