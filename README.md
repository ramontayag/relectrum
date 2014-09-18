# Relectrum

Ruby Wrapper for Electrum

## Installation

Add this line to your application's Gemfile:

    gem 'relectrum'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install relectrum

## Usage

```
Relectrum.configure do |c|
  c.electrum_path = "/path/to/electrum"
  c.sx_path = "/path/to/sx"
end
```

```
# You can also override the paths here:
relectrum = Relectrum.new(
  electrum_path: "/path/to/electrum",
  sx_path: "/path/to/sx",
)

relectrum.get_address_balance("XYZ") # { confirmed: "20.1221", unconfirmed: "8.982" }
```

### Relectrum::Wrapper

A thin wrapper around the command line actions you can perform on Electrum. Hardly any adulteration is done to the data returned.

See other commands in `spec/relectrum/wrapper_spec.rb`.

## Contributing

This has been developed on Ubuntu with Electrum 1.9.8.

Copy `spec/config.yml.sample` to `spec/config.yml` and fill in the details.

1. Fork it ( https://github.com/ramontayag/relectrum/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
