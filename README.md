### Is a

Build source of Japanese flavored archlinux box ( https://app.vagrantup.com/ippsio/boxes/archlinux_xfce4_ja ).

- v4.19.4-arch1 with
  - xfce4 + lightdm (GUI Desktop)
  - fcitx + fcitx_mozc (IME)
  - chromium (Web browser)
  - docker + docker-compose (Container platform)

If you would like to change keyboard setting into Japanese keyboard, then execute `sudo localectl set-keymap jp106`

### If you want to use quickly

You can use vagrant box image.

```
Vagrant.configure("2") do |config|
  config.vm.box = "ippsio/archlinux_xfce4_ja"
  config.vm.box_version = "1.0"
end
```
