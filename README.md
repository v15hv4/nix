# nix

## Profiles
```
- personal
- work
- server
```

## Setup
```
sudo nixos-rebuild switch --impure --flake github:v15hv4/nix#<profile>
```

## Development
```
nix flake clone github:v15hv4/nix --dest ~/nix
```
