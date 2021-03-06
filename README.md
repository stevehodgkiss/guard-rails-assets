# Guard::RailsAssets


Guard::RailsAssets compiles the assets in Rails 3.1 application automatically when files are modified.

Tested on MRI Ruby 1.9.2 (please report if it works on your platform).

If you have any questions please contact me [@dnagir](http://www.ApproachE.com).

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed.

Install the gem:

Add it to your `Gemfile`, preferably inside the test and development group:

```ruby
gem 'guard-rails-assets'
```

Add guard definition to your `Guardfile` by running:

```bash
$ guard init rails-assets
```

## Rails 3.1

The Rails 3.1 is a mandatory requirement, but is not enforced via dependencies for now.
The reason is that the assets can currently be compiled using following "runners":

1. rake command (CLI);
2. loading the actual Rails environment.

In the 1st case - this Guard is not actually using Rails directly while in the 2nd - it loads it explicitly.

Good thing about the 1st approach is that assets will always be same as produced by Rails.
Bad thing is that it is pretty slow (~10 seconds) because it starts Rails from ground zero.

The 2nd approach is good because it is much faster, but does not reload Rails environment (so you have to restart guard).

## Guardfile and Options

In addition to the standard configuration, this Guard has options to specify when exactly to precompile assets.

- `:start` - compile assets when the guard starts (enabled by default)
- `:change` - compile assets when watched files change (enabled by default)
- `:reload` - compile assets when the guard quites (Ctrl-C) (not enabled by default)
- `:all` - compile assets when running all the guards (Ctrl-/) (not enabled by default)

Also you can set the `:runner` option:

- `:cli` - compile assets using the rake task - the most correct method, but slow.
- `:rails` - compile assets by loading rails environment (default) - fast, but does not pick up changes.

If you're using sprockets standalone or with sinatra, you can override the rails
runners sprockets environment and environment_path with your custom settings.

- `:sprockets_environment` - a lambda that returns an instance of Sprockets::Environment. E.g. `lambda { App.sprockets }`
- `:environment_path` - defaults to "config/environment.rb"
- `:precompile` - an array of assets to precompile. Required if you're not using Rails. E.g. `["*"]`


For example:


```ruby
# This is the default behaviour
guard 'rails-assets', :run_on => [:start, :change], :runner => :rails do
  watch(%r{^app/assets/.+$})
end

# compile ONLY when something changes
guard 'rails-assets', :run_on => :change do
  watch(%r{^app/assets/.+$})
end

# compile when something changes and when starting
guard 'rails-assets', :run_on => [:start, :change] do
  watch(%r{^app/assets/.+$})
end

# Non-rails configuration
guard 'rails-assets', :sprockets_environment => lambda { App.sprockets }, :environment_path => "app.rb", :precompile => ["*"] do
  watch(%r{^app/assets/.+$})
  watch('app.rb')
end
```

## Development

- Source hosted at [GitHub](https://github.com/dnagir/guard-rails-assets)
- Report issues and feature requests to [GitHub Issues](https://github.com/dnagir/guard-rails-assets/issues)

Pull requests are very welcome!

## Licensed under WTFPL

```
            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2011 Dmytrii Nagirniak <dnagir@gmail.com>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.
```
