require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # Core modules, needed for most of the things.
  include dnsmasq
  include git
  include hub

  # Fail if FDE is not enabled.
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # The node versions.
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10

  # Install the HEAD rbenv version, as this one comes with fish support.
  class { 'ruby': rbenv_version => HEAD }

  # The ruby versions.
  include ruby::1_8_7
  include ruby::1_9_2
  include ruby::1_9_3
  include ruby::2_0_0

  # The useful packages.
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'zsh',
      'direnv',
      'autojump',
      'git',
      'mercurial',
      'wget',
      'coreutils',
      'lua',
      'macvim',
      'tmux',
      'reattach-to-user-namespace',
      'ctags',
      'ag',
      'imagemagick',
      'gifsicle',
    ]:
  }

  # Install Skype and Google Chrome through homebrew-cask.
  include brewcask

  package {
    [
      'skype',
      'google-chrome',
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
