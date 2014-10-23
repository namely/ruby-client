module Namely
  class Field < RestfulModel
    def self.endpoint
      "profiles/fields"
    end

    def self.resource_name
      "fields"
    end
  end
end
