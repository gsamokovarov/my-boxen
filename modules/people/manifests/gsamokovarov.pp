class people::gsamokovarov {
  $home = "/Users/${::boxen_user}"

  # The useful packages from Homebrew.
  package {
    [
      'direnv',
      'autojump',
      'ctags',
      'ag',
      'imagemagick',
      'gifsicle',
    ]:
  }

  # The useful packages from Homebrew.
  # install_options.
  package { 'macvim':
    install_options => ['--override-system-vim', '--with-lua']
  }

  # Install Skype and Google Chrome, and XQuartz through homebrew-cask.
  package {
    [
      'skype',
      'google-chrome',
      'xquartz',
    ]:
      provider => 'brewcask',
      require  => Class['brewcask']
  }

  # Install iTerm2 with the Solarized Light theme. You need to explicitly
  # specify the dependency, as `iterm2::colors::solarized_light` doesn't do it.
  class { 'iterm2::dev': } -> class { 'iterm2::colors::solarized_light': }

  # Install VMware Fusion. All the <3 for VMware.
  include vmware_fusion

  # Install vagrant with VMware Fusion support. I'll add the license manually.
  include vagrant

  vagrant::plugin { 'vagrant-vmware-fusion': }

  # I bought alfred for a plasibo based productivity increase. Have it
  # installed by default.
  include alfred

  # Include viscosity as I use for a couple of VPN connections.
  include viscosity

  # Fish is my favorite shell in the moment. Install it and set it as the
  # default shell.
  include fish
}
