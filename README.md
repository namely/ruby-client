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

## Configuration

You'll need to configure the gem to use your Namely account. Do this
by setting the `access_token` and `subdomain` variables in a
configuration block:

```ruby
Namely.configure do |config|
  config.access_token = "your_access_token"
  config.subdomain = "your-organization"
end
```

An access token can be obtained through your organization's Namely
account.

Namely associates a subdomain with your
organization. organization. For example, if your account is at
`http://your-organization.namely.com/`, your subdomain would be
`"your-organization"`.

In a Rails application this configuration belongs in
`config/initializers/namely.rb`.

## Usage Examples

```ruby
Namely::Country.all.each do |country|
  puts "#{country.id} - #{country.name}"
end
# AF - Afghanistan
# AL - Albania
# DZ - Algeria
# AS - American Samoa
# ...
```

```ruby
if Namely::Country.exists?("BE")
  "Belgium exists!"
else
  "Hmm."
end # => "Belgium exists!"
```

```ruby
Namely::Country.find("BE")
# => <Namely::Country id="BE", name="Belgium", subdivision_type="Province", links={"subdivisions"=>[{"id"=>"BRU", "name"=>"Brussels"}, {"id"=>"VAN", "name"=>"Antwerpen (nl)"}, {"id"=>"VBR", "name"=>"Vlaams Brabant (nl)"}, {"id"=>"VLI", "name"=>"Limburg (nl)"}, {"id"=>"VOV", "name"=>"Oost-Vlaanderen (nl)"}, {"id"=>"VWV", "name"=>"West-Vlaanderen (nl)"}, {"id"=>"WBR", "name"=>"Brabant Wallon (fr)"}, {"id"=>"WHT", "name"=>"Hainaut (fr)"}, {"id"=>"WLG", "name"=>"Liège (fr)"}, {"id"=>"WLX", "name"=>"Luxembourg (fr)"}, {"id"=>"WNA", "name"=>"Namur (fr)"}]}>
```

```ruby
foo_bar = Namely::Profile.create!(
  first_name: "Metasyntactic",
  last_name: "Variable",
  email: "foo_bar@namely.com"
)

foo_bar.id # => "37c919e2-f1c8-4beb-b1d4-a9a36ccc830c"
```

## Contributing

Wanna help out? Great! Here are a few resources that might help you
started:

* Documentation on [Namely's HTTP API]
* Namely tries to stick to the [JSON API standard]. If we're seriously
  deviating from it, that may well be a bug.
* For coding style, we like [thoughtbot's style guide]

Here's the process:

1. [Fork it!]
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`). Be sure
   to include tests!
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request. We'll review it and leave feedback for
   you ASAP.

[Namely's HTTP API]: http://namely.readme.io/v1/docs
[thoughtbot's style guide]: https://github.com/thoughtbot/guides/tree/master/style
[JSON API standard]: http://jsonapi.org/
[Fork it!]: https://github.com/namely/ruby-client/fork
