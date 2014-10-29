module Namely
  class Profile < RestfulModel
    def self.endpoint
      "profiles"
    end

    def required_keys_for_update
      [:email]
    end

    private_class_method :endpoint, :resource_name
  end
end
