class people::gsamokovarov {
  $user = $::boxen_user
  $home = "/Users/${user}"

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
      'moreutils',
      'git-extras',
      'tree',
      'ssh-copy-id'
    ]:
  }

  # Install HEAD vim to get the latest rendering optimizations. They help a
  # bit with the terminal Vim.
  package { 'vim':
    install_options => ['--HEAD', '--override-system-vim', '--with-lua']
  }

  package {
    [
      'skype',
      'google-chrome',
    ]:
      provider => 'brewcask',
      require  => Class['brewcask']
  }

  # Hub for git.
  include hub

  # Manage my passwords with 1Password.
  include onepassword

  # You know, for X apps.
  include xquartz

  # Install iTerm2 with the Solarized Light theme. You need to explicitly
  # specify the dependency, as `iterm2::colors::solarized_light` doesn't do it.
  class { 'iterm2::dev': } -> class { 'iterm2::colors::solarized_light': }

  # Install VMware Fusion. All the <3 for VMware.
  include vmware_fusion

  # Install vagrant with VMware Fusion support. I'll add the license manually.
  class { 'vagrant':
    version    => '1.7.2',
    completion => true
  }

  vagrant::plugin { 'vagrant-vmware-fusion': }

  # I bought alfred for a plasibo based productivity increase. Have it
  # installed by default.
  include alfred

  # Include viscosity as I use for a couple of VPN connections.
  include viscosity

  # Flux is great, lowering the blue during the night helps a lot.
  include flux

  # Stops the laptop from sleeping on deploys. Live saver.
  include caffeine

  # Fish is my favorite shell in the moment. Install it and set it as the
  # default shell.
  include fish

  # Include Java 7.
  include java

  # Easily record gifs.
  include licecap

  # Hacker friendly way to get all you documentation, even offline.
  include dash

  # Settings
  # --------

  # Force file shares to use an older Samba version. My OpenELEC media center
  # can't open the new Samba shares that came by default with Mavericks.
  file { "${home}/Library/Preferences/nsmb.conf":
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
      key    => 'AppleEnableMenuBarTransparency',
      domain => 'NSGlobalDomain',
      value  => true;

    'Use all F1, F2, etc. keys as media function keys':
      key    => 'com.apple.keyboard.fnState',
      domain => 'NSGlobalDomain',
      value  => false;

    'Display the battery charge in a percentage':
      key    => 'ShowPercent',
      domain => 'com.apple.menuextra.battery',
      type   => 'string',
      value  => 'YES';

    'Disable mouse (not trackpad) acceleration':
      key    => 'com.apple.mouse.scaling',
      domain => '.GlobalPreferences',
      type   => 'int',
      value  => 1;

    'Disable guest login to the machine itself':
      key    => 'GuestEnabled',
      domain => '/Library/Preferences/com.apple.loginwindow.plist',
      value  => false;

    'Allow guests to connect to shared folders':
      key    => 'AllowGuestAccess',
      domain => '/Library/Preferences/SystemConfiguration/com.apple.smb.server.plist',
      value  => true;

    'Disable the dashboard':
      key    => 'mcx-disabled',
      domain => 'com.apple.dashboard',
      value  => true;

    "Don't show Dashboard as a Space":
      key    => 'dashboard-in-overlay',
      domain => 'com.apple.dock',
      value  => true;

    'Increase Time Machine backup interval to 6 hours':
      key    => 'StartInterval',
      domain => '/System/Library/LaunchDaemons/com.apple.backupd-auto.plist',
      user   => 'root',
      type   => 'int',
      value  => '21600';
  }
}
