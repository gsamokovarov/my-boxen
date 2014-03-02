class people::gsamokovarov {
  $user = $boxen_user
  $home = "/Users/${::boxen_user}"

  # Repositories
  # ------------

  file { "${home}/Development":
    ensure => directory
  }

  repository { "${home}/Development/.files":
    source => 'gsamokovarov/.files'
  }

  exec { 'make':
    cwd     => "${home}/Development/.files",
    require => Repository["${home}/Development/.files"]
  }

  # Packages
  # --------

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

  # Settings
  # --------

  # Force file shares to use an older Samba version. My OpenELEC media center
  # can't open the new Samba shares that came by default with Mavericks.
  file { "${home}/Library/Preferences/nsmb.conf":
    owner  => $user,
    source => 'puppet:///modules/people/gsamokovarov/nsmb.conf'
  }

  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_remote_control_ir_receiver
  include osx::global::disable_autocorrect
  include osx::global::natural_mouse_scrolling
  class { 'osx::global::key_repeat_delay': delay => 20 }

  include osx::keyboard::capslock_to_control

  include osx::dock::autohide
  class { 'osx::dock::position': position => left }
  class { 'osx::dock::icon_size': size => 62 }

  include osx::finder::show_removable_media_on_desktop
  include osx::finder::empty_trash_securely
  include osx::finder::unhide_library
  include osx::finder::enable_quicklook_text_selection

  include osx::universal_access::ctrl_mod_zoom
  include osx::universal_access::cursor_size

  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  include osx::software_update

  boxen::osx_defaults {
    'Enable the menu bar transparency':
      user   => $::boxen_user,
      key    => 'AppleEnableMenuBarTransparency',
      domain => 'NSGlobalDomain',
      value  => true;

    'Use all F1, F2, etc. keys as standard function keys.':
      user   => $::boxen_user,
      key    => 'com.apple.keyboard.fnState',
      domain => 'NSGlobalDomain',
      value  => true;

    'Display the battery charge in a percentage':
      user   => $::boxen_user,
      key    => 'ShowPercent',
      domain => 'com.apple.menuextra.battery',
      type   => 'string',
      value  => 'YES';

    'Disable mouse (not trackpad) acceleration':
      user   => $::boxen_user,
      key    => 'com.apple.mouse.scaling',
      domain => '.GlobalPreferences',
      type   => 'int',
      value  => 1;
  }
}
