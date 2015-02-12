# chef-cmake [![Build Status](http://img.shields.io/travis-ci/phlipper/chef-cmake.png)](https://travis-ci.org/phlipper/chef-cmake)

## Description

Installs [cmake](http://www.cmake.org/), the cross-platform, open-source build system.


## Requirements

### Supported Platforms

The following platforms are supported by this cookbook, meaning that the
recipes should run on these platforms without error:

* Ubuntu 12.04+
* Debian 6.0.8+
* CentOS/RedHat 6+
* Fedora 20+

### Cookbooks

* [build-essential](http://community.opscode.com/cookbooks/build-essential) _(used for source install)_

### Chef

It is recommended to use a version of Chef `>= 10.16.4` as that is the target of my usage and testing, though this should work with most recent versions.

### Ruby

This cookbook requires Ruby 1.9+ and is tested against:

* 1.9.3
* 2.0.0
* 2.1.2


## Recipes

* `cmake::default` - The default recipe which installs the package.


## Usage

This cookbook installs the cmake components if not present, and pulls updates if they are installed on the system.


## Attributes

```ruby
default["cmake"]["install_method"] = "package" # `package` or `source`

default["cmake"]["source"]["version"] = "2.8.12.2"
default["cmake"]["source"]["checksum"] = "8c6574e9afabcb9fc66f463bb1f2f051958d86c85c37fccf067eb1a44a120e5e"
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Contributors

Many thanks go to the following [contributors](https://github.com/phlipper/chef-cmake/graphs/contributors) who have helped to make this cookbook even better:

* **[@pfalcone](https://github.com/pfalcone)**
    * add initial support for RedHat-based distributions
* **[@odeits](https://github.com/odeits)**
    * initial implementation of source installation recipe


## License

**chef-cmake**

* Freely distributable and licensed under the [MIT license](http://phlipper.mit-license.org/2012-2014/license.html).
* Copyright (c) 2012-2014 Phil Cohen (github@phlippers.net) [![endorse](http://api.coderwall.com/phlipper/endorsecount.png)](http://coderwall.com/phlipper) [![Gittip](http://img.shields.io/gittip/phlipper.png)](https://www.gittip.com/phlipper/)
* http://phlippers.net/
