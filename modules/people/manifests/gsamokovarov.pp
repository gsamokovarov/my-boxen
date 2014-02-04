class people::gsamokovarov {
  $home = "/Users/${::boxen_user}"

  file { "${home}/.rbenv":
    ensure => link,
    target => "${::boxen_home}/rbenv"
  }
}
