### Is a

Build source of Japanese flavored archlinux box ( https://app.vagrantup.com/ippsio/boxes/archlinux_xfce4_ja ).

- 4.20.6-arch1-1-ARCH with
  - xfce4 / lxde + lxdm (GUI Desktop)
  - fcitx + fcitx_mozc (IME)
  - firefox / chromium (Web browser)

If you would like to change keyboard setting into Japanese keyboard, then execute `sudo localectl set-keymap jp106`

### If you want to use quickly

You can use vagrant box image.

```
Vagrant.configure("2") do |config|
  config.vm.box = "ippsio/archlinux_xfce4_ja"
  config.vm.box_version = "1.0"
end
```
