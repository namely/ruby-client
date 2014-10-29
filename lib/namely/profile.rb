module Namely
  class Profile < RestfulModel
    def self.endpoint
      "profiles"
    end

    private_class_method :endpoint, :resource_name
  end
end
