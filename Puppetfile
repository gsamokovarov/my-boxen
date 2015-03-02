# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "boxen/puppet-#{name}"
    mod name, version, :github_tarball => options[:repo]
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod "puppet-#{name}", :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.10.1"

# Support for default hiera data in modules

github "module_data", "0.0.3", :repo => "ripienaar/puppet-module-data"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "dnsmasq"
github "foreman"
github "gcc"
github "git"
github "go"
github "homebrew"
github "openssl"
github "phantomjs"
github "pkgconfig"
github "repository"
github "sudo"

mod "inifile", :github_tarball => "puppetlabs/puppetlabs-inifile"
mod "stdlib", :github_tarball => "puppetlabs/puppetlabs-stdlib"

# Too lazy to lock the versions, now.
github "fish"
github "osx"
github "dropbox"
github "vagrant"
github "vmware_fusion"
github "alfred"
github "flux"
github "viscosity"
github "caffeine"
github "sourcetree"
github "xquartz"
github "onepassword"
github "knock"
github "eclipse"
github "java"
github "licecap"
github "slate"
github "pcloud"
github "iterm2"
github "brewcask"
github "hub"
