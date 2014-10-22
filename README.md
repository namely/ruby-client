# Namely

[![Travis](https://travis-ci.org/namely/ruby-client.svg?branch=master)](https://travis-ci.org/namely/ruby-client/builds)
[![Code Climate](https://codeclimate.com/github/namely/ruby-client/badges/gpa.svg)](https://codeclimate.com/github/namely/ruby-client)

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem "namely"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install namely

## Usage

You'll need to configure the gem to use your Namely account. Do this
by setting the `access_token` and `site_name` variables in a
configuration block:

```ruby
Namely.configure do |config|
  config.access_token = "your_access_token"
  config.site_name = "your-organization"
end
```

An access token can be obtained through your organization's Namely
account.

Your site name is just the subdomain that Namely associates with your
organization. For example, if your account is at
`http://your-organization.namely.com/`, your site name would be
`"your-organization"`.

In a Rails application this configuration belongs in
`config/initializers/namely.rb`.

## Contributing

1. [Fork it!](https://github.com/namely/ruby-client/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`). Be sure
   to include tests!
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
