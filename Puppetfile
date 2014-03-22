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
  mod name, :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.3.4"

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
github "iterm2"
github "dropbox"
github "vagrant"
github "vmware_fusion"
github "alfred"
github "flux"
github "viscosity"
github "caffeine"

mod "knock", :git => "git@github.com:gsamokovarov/puppet-knock.git"
mod "brewcask", :git => "git@github.com:phinze/puppet-brewcask.git"
