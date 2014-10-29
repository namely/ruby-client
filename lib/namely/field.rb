module Namely
  class Field < RestfulModel
    def self.endpoint
      "profiles/fields"
    end

    private_class_method :endpoint, :resource_name
  end
end
