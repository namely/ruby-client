module Namely
  class JobTier < RestfulModel
    def self.endpoint
      "job_tiers"
    end

    private_class_method :endpoint
  end
end
