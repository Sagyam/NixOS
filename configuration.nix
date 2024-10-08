# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Extra hosts
  networking.extraHosts =
  ''
    159.65.215.188 dev-api.bitmosys.com
    159.65.215.188 docs.dev-api.bitmosys.com
    159.65.215.188 uptime.dev-api.bitmosys.com
    159.65.215.188 metrics.dev-api.bitmosys.com
    159.65.215.188 dashboard.dev-api.bitmosys.com
    159.65.215.188 trace.dev-api.bitmosys.com
    159.65.215.188 rabbitmq.dev-api.bitmosys.com
    159.65.215.188 code.dev-api.bitmosys.com
  '';



  # Enable bluetooth
  hardware.bluetooth = {
	enable = true;
	powerOnBoot = true;
	package = pkgs.bluez5-experimental;
	settings.Policy.AutoEnable = "true";
	settings.General.Enable = "Source,Sink,Media,Socket";
	settings.General.ControllerMode = "dual";	
	settings.General.FastConnectable = "true";
	settings.General.Experimental = "true";
	settings.General.KernelExperimental = "true";
   };
   services.blueman.enable = true;
  
  

  # Set your time zone.
  time.timeZone = "Asia/Kathmandu";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sagyam = {
    isNormalUser = true;
    description = "sagyam";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [

    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  # Setup docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
  	enable = true;
  	setSocketVariable = true;
  };

 # Virtulization
 virtualisation.virtualbox.host.enable = true;
 virtualisation.virtualbox.host.enableKvm = true;
 virtualisation.virtualbox.host.addNetworkInterface = false;
 users.extraGroups.vboxusers.members = [ "sagyam" ];
 virtualisation.virtualbox.host.enableExtensionPack = true;
 virtualisation.virtualbox.guest.enable = true;
 virtualisation.virtualbox.guest.draganddrop = true;
 virtualisation.virtualbox.guest.clipboard = true;
 virtualisation.virtualbox.guest.seamless = true;

 # GPG config
  services.pcscd.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  aria2
  audiobookshelf
  bandwhich
  bat
  btop
  curl
  diff-so-fancy
  doctl
  dogdns
  duf
  eza
  fastfetch
  firefox
  gh
  git
  gnupg
  gping
  helmfile
  httpie
  intel-one-mono
  jellyfin
  jellyfin-ffmpeg	
  jellyfin-media-player
  jellyfin-mpv-shim
  jellyfin-web
  jetbrains-toolbox
  k9s
  kubernetes
  (wrapHelm kubernetes-helm {
    plugins = with pkgs.kubernetes-helmPlugins; [
      helm-secrets
      helm-diff
      helm-s3
      helm-git
    ];
  })
  lazydocker
  lazygit
  minikube
  neovim
  nerdfetch
  nerdfonts
  nodejs_22
  oh-my-zsh
  pnpm
  qbittorrent
  scc
  spotify
  tmux
  thefuck
  tor-browser
  varia
  vlc
  vscode
  zsh
  zsh-autocomplete
  zsh-autosuggestions
  zsh-bd
  zsh-powerlevel10k
  zsh-syntax-highlighting
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [8000 8920 8096];
  networking.firewall.allowedUDPPorts = [1900 7359 7359];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Allow connection via hostname usign Avahi
  services.avahi = {
  	enable = true;
  	nssmdns = true;
  	publish = {
    	enable = true;
    	addresses = true;
    	workstation = true;
  	};
};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
