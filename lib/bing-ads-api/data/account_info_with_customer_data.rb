module BingAdsApi
  class AccountInfoWithCustomerData < DataObject
    include BingAdsApi::AccountLifeCycleStatuses

    attr_accessor :customer_id, :customer_name,
                  :account_id, :account_name,
                  :account_number, :account_lifecycle_status, :pause_reason
  end
end
