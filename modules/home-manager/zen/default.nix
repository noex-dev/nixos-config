{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.zen-browser.homeModules.default
  ];

  home.packages = with pkgs; [
    hunspellDicts.de_AT
  ];

  programs.zen-browser = {
    enable = true;
    profiles.default = {
      isDefault = true;

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        darkreader
        bitwarden
        ublock-origin
        snowflake
        multi-account-containers
      ];

      containers = {
        entertainment = {
          id = 1;
          name = "Entertainment";
          icon = "chill";
          color = "purple";
        };
        development = {
          id = 2;
          name = "Development";
          icon = "fingerprint";
          color = "blue";
        };
        school = {
          id = 3;
          name = "School";
          icon = "briefcase";
          color = "red";
        };
      };

      bookmarks = {
        force = true;
        settings = [
          {
            name = "Bookmarks Toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "Media";
                bookmarks = [
                  {
                    name = "YouTube";
                    url = "https://youtube.com/";
                    keyword = "yt";
                  }
                  {
                    name = "YT Music";
                    url = "https://music.youtube.com/";
                    keyword = "ym";
                  }
                  {
                    name = "Twitch";
                    url = "https://twitch.tv/";
                    keyword = "ttv";
                  }
                  {
                    name = "WhatsApp Web";
                    url = "https://web.whatsapp.com/";
                    keyword = "wa";
                  }
                ];
              }
              {
                name = "Dev & Sec";
                bookmarks = [
                  {
                    name = "GitHub";
                    url = "https://github.com/";
                    keyword = "gh";
                  }
                  {
                    name = "Cloudflare";
                    url = "https://dash.cloudflare.com/";
                    keyword = "cf";
                  }
                  {
                    name = "NVD";
                    url = "https://nvd.nist.gov/";
                  }
                  {
                    name = "Shodan";
                    url = "https://www.shodan.io/";
                  }
                  {
                    name = "HackTheBox";
                    url = "https://www.hackthebox.com/";
                    keyword = "htb";
                  }
                ];
              }
              {
                name = "Tools";
                bookmarks = [
                  {
                    name = "Claude AI";
                    url = "https://claude.ai/";
                    keyword = "cai";
                  }
                  {
                    name = "DeepL";
                    url = "https://deepl.com/translate";
                    keyword = "dl";
                  }
                  {
                    name = "CyberChef";
                    url = "https://gchq.github.io/CyberChef/";
                    keyword = "cc";
                  }
                  {
                    name = "VirusTotal";
                    url = "https://www.virustotal.com/";
                    keyword = "vt";
                  }
                  {
                    name = "Wayback Machine";
                    url = "https://web.archive.org/";
                    keyword = "wb";
                  }
                  {
                    name = "Programiz";
                    url = "https://www.programiz.com/";
                  }
                  {
                    name = "Regex101";
                    url = "https://regex101.com/";
                    keyword = "rx";
                  }
                  {
                    name = "Removal.ai";
                    url = "https://removal.ai/";
                    keyword = "rai";
                  }
                ];
              }
              {
                name = "Shopping";
                bookmarks = [
                  {
                    name = "Amazon";
                    url = "https://www.amazon.de/";
                    keyword = "amz";
                  }
                  {
                    name = "Geizhals";
                    url = "https://geizhals.at/";
                    keyword = "ghz";
                  }
                  {
                    name = "Willhaben";
                    url = "https://www.willhaben.at/";
                    keyword = "wh";
                  }
                  {
                    name = "Aurena";
                    url = "https://www.aurena.at/";
                  }
                  {
                    name = "Bambu Store";
                    url = "https://eu.store.bambulab.com/";
                    keyword = "bs";
                  }
                ];
              }
              {
                name = "NixOS";
                bookmarks = [
                  {
                    name = "Package Search";
                    url = "https://search.nixos.org/packages";
                    keyword = "np";
                  }
                  {
                    name = "Options Search";
                    url = "https://search.nixos.org/options";
                    keyword = "no";
                  }
                  {
                    name = "NixOS Wiki";
                    url = "https://nixos.wiki/";
                    keyword = "nw";
                  }
                  {
                    name = "Nixpkgs GitHub";
                    url = "https://github.com/NixOS/nixpkgs";
                    keyword = "npg";
                  }
                  {
                    name = "Awesome Nix";
                    url = "https://github.com/nix-community/awesome-nix";
                    keyword = "awx";
                  }
                  {
                    name = "Noogle";
                    url = "https://noogle.dev/";
                  }
                ];
              }
              {
                name = "School";
                bookmarks = [
                  {
                    name = "WebUntis";
                    url = "https://nete.webuntis.com/";
                    keyword = "wu";
                  }
                  {
                    name = "Eduvidual";
                    url = "https://eduvidual.at/";
                    keyword = "edu";
                  }
                  {
                    name = "Digi4School";
                    url = "https://digi4school.at/ebooks";
                    keyword = "d4s";
                  }
                  {
                    name = "EBCL";
                    url = "https://world.ebcl.eu/";
                  }
                ];
              }
              {
                name = "HomeLab";
                bookmarks = [
                  {
                    name = "Synology DS224+";
                    url = "https://synology.noex.dev/";
                    keyword = "snd";
                  }
                  {
                    name = "Proxmox";
                    url = "https://proxmox.noex.dev/";
                    keyword = "pnd";
                  }
                  {
                    name = "AI Server";
                    url = "https://ai.noex.dev";
                    keyword = "aind";
                  }
                  {
                    name = "Adguard Home";
                    url = "https://adguard.noex.dev/";
                    keyword = "adnd";
                  }
                  {
                    name = "Vaultwarden";
                    url = "https://vaultwarden.noex.dev/";
                    keyword = "vnd";
                  }
                  {
                    name = "Uptime Kuma";
                    url = "https://uptime.noex.dev";
                    keyword = "und";
                  }
                  {
                    name = "Home Assistant";
                    url = "https://home-assistant.noex.dev/";
                    keyword = "hand";
                  }
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
