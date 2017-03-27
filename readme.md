# Installation

First install `rkt` and `acbuild` and ensure the user running `./build.zsh` has `sudo` access to (at least) `rkt` and `acbuild`.

```
./build.zsh
sudo ./install.zsh
```

# Usage

```
sonkar cfg.ovpn
```

This runs a container in which openvpn will connect using the config `cfg.ovpn`. The container also runs a DNS server and socks5 server which can be used to forward requests over the openvpn while leaving your default networking outside of the vpn.