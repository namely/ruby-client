require "spec_helper"

describe Namely::Configuration do
  before :each do
    unset_configuration!
  end

  after :each do
    set_configuration!
  end

  it "contains a subdomain and access_token when those have been set" do
    Namely.configure do |config|
      config.access_token = "my_token"
      config.subdomain = "my_subdomain"
    end

    expect(Namely.configuration.access_token).to eq "my_token"
    expect(Namely.configuration.subdomain).to eq "my_subdomain"
  end

  it "raises an error when the configuration block hasn't been run" do
    expect { Namely.configuration }.to raise_error Namely::ImproperlyConfiguredError
  end

  it "raises an error when variables haven't been set in the config" do
    Namely.configure do
    end

    expect { Namely.configuration.access_token }.to raise_error Namely::ImproperlyConfiguredError
    expect { Namely.configuration.subdomain }.to raise_error Namely::ImproperlyConfiguredError
  end
end
