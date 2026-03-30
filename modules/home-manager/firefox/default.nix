{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "default";
      isDefault = true;

      bookmarks = {
        force = true;
        settings = [
          {
            name = "Bookmarks Toolbar";
            toolbar = true;
            bookmarks = [
              # --- 1. MEDIA ---
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

              # --- 2. DEV & SEC ---
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

              # --- 3. TOOLS ---
              {
                name = "Tools";
                bookmarks = [
                  {
                    name = "Gemini";
                    url = "https://gemini.google.com/";
                    keyword = "gai";
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

              # --- 4. SHOPPING ---
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

              # --- 5. NIXOS ---
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

              # --- 6. SCHOOL ---
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
            ];
          }
        ];
      };

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        ublock-origin
        bitwarden
        darkreader
        snowflake
      ];

      settings = {
        # --- GENERAL & UI ---
        "browser.aboutConfig.showWarning" = false;
        "browser.quitShortcut.disabled" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.page" = 3;
        "browser.tabs.inTitlebar" = 1;
        "browser.theme.toolbar-theme" = 0;
        "browser.toolbars.bookmarks.visibility" = "always";
        "intl.locale.requested" = "en-GB,en-US";
        "layout.css.always_underline_links" = true;
        "widget.gtk.overlay-scrollbars.enabled" = false;
        "media.eme.enabled" = true;

        # --- BOOKMARKS FIX ---
        "browser.places.importBookmarksHTML" = true;

        # --- DOWNLOADS ---
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.download.autohideButton" = false;
        "browser.download.useDownloadDir" = false;
        "browser.download.viewableInternally.typeWasRegistered.avif" = true;
        "browser.download.viewableInternally.typeWasRegistered.webp" = true;

        # --- NEW TAB PAGE & UI CLUTTER ---
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.system.showWeatherOptIn" = false;

        # --- PRIVACY, SECURITY & AI BLOCKING ---
        "browser.ai.control.default" = "blocked";
        "browser.ai.control.linkPreviewKeyPoints" = "blocked";
        "browser.ai.control.pdfjsAltText" = "blocked";
        "browser.ai.control.sidebarChatbot" = "blocked";
        "browser.ai.control.smartTabGroups" = "blocked";
        "browser.ai.control.translations" = "blocked";
        "browser.history.allowHistory" = false;
        "dom.battery.enabled" = false;
        "dom.forms.autocomplete.formautofill" = true;
        "identity.fxaccounts.enabled" = false;
        "places.history.enabled" = false;
        "privacy.clearOnShutdown_v2.formdata" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "signon.autofillForms" = false;
        "signon.generation.enabled" = false;
        "signon.management.page.breach-alerts.enabled" = false;
        "signon.rememberSignons" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        # --- TELEMETRY & DATA COLLECTION  ---
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "browser.discovery.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "browser.pingcentre.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

        # --- EXTENSIONS & PERFORMANCE ---
        "extensions.autoDisableScopes" = 0;
        "extensions.enabledScopes" = 15;
        "extensions.startupScanScopes" = 15;
        "gfx.webrender.all" = true;
        "network.dns.disablePrefetch" = true;
        "network.http.max-connections" = 1800;
        "network.http.max-persistent-connections-per-server" = 10;
        "nglayout.initialpaint.delay" = 0;

        # --- TOOLBAR LAYOUT ---
        "browser.uiCustomization.state" = builtins.toJSON {
          currentVersion = 23;
          newElementCount = 6;
          dirtyAreaCache = [
            "nav-bar"
            "vertical-tabs"
            "PersonalToolbar"
            "unified-extensions-area"
            "toolbar-menubar"
            "TabsToolbar"
          ];
          placements = {
            PersonalToolbar = [ "personal-bookmarks" ];
            TabsToolbar = [
              "tabbrowser-tabs"
              "new-tab-button"
              "alltabs-button"
            ];
            nav-bar = [
              "preferences-button"
              "developer-button"
              "back-button"
              "forward-button"
              "vertical-spacer"
              "stop-reload-button"
              "urlbar-container"
              "_b11bea1f-a888-4332-8d8a-cec372b66621_-browser-action"
              "addon_darkreader_org-browser-action"
              "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
              "ublock0_raymondhill_net-browser-action"
              "unified-extensions-button"
              "fxa-toolbar-menu-button"
            ];
            toolbar-menubar = [ "menubar-items" ];
            unified-extensions-area = [ ];
            vertical-tabs = [ ];
            widget-overflow-fixed-list = [ ];
          };
          seen = [
            "developer-button"
            "screenshot-button"
            "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
            "addon_darkreader_org-browser-action"
            "ublock0_raymondhill_net-browser-action"
            "_b11bea1f-a888-4332-8d8a-cec372b66621_-browser-action"
          ];
        };
      };
    };
  };

  # --- HANDLERS ---
  home.file.".mozilla/firefox/default/handlers.json".text = builtins.toJSON {
    defaultHandlersVersion = { };
    isDownloadsImprovementsAlreadyMigrated = false;
    mimeTypes = {
      "application/pdf" = {
        action = 3;
        extensions = [ "pdf" ];
      };
      "image/avif" = {
        action = 3;
        extensions = [ "avif" ];
      };
      "image/webp" = {
        action = 3;
        extensions = [ "webp" ];
      };
    };
    schemes.mailto = {
      handlers = [
        null
        {
          name = "Gmail";
          uriTemplate = "https://mail.google.com/mail/?extsrc=mailto&url=%s";
        }
      ];
      stubEntry = true;
    };
  };
}
