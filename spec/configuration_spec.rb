require "spec_helper"

describe Namely::Configuration do
  before :each do
    unset_configuration!
  end

  after :each do
    set_configuration!
  end

  it "contains a site_name and access_token when those have been set" do
    Namely.configure do |config|
      config.access_token = "my_token"
      config.site_name = "my_site"
    end

    expect(Namely.configuration.access_token).to eq "my_token"
    expect(Namely.configuration.site_name).to eq "my_site"
  end

  it "raises an error when the configuration block hasn't been run" do
    expect { Namely.configuration }.to raise_error Namely::ImproperlyConfiguredError
  end

  it "raises an error when variables haven't been set in the config" do
    Namely.configure do
    end

    expect { Namely.configuration.access_token }.to raise_error Namely::ImproperlyConfiguredError
    expect { Namely.configuration.site_name }.to raise_error Namely::ImproperlyConfiguredError
  end
end
