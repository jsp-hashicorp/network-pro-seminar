#cloud-config
write_files:
  - path: /config/custom-config.sh
    permissions: 0755
    owner: root:root
    content: |
      #!/bin/bash
      tmsh modify auth user admin { password ${password} }
      tmsh modify auth user admin shell bash
      tmsh modify sys global-settings gui-setup disabled

      # CVE-2020-5902
      # see: https://support.f5.com/csp/article/K52145254
      #
      # This is not necessary as long as you are running > 15.1.0.4
      #
      # tmsh modify sys httpd include '"
      # CVE-2020-5902
      #<LocationMatch "\"";"\"">
      #   Redirect 404 /
      #</LocationMatch>
      #<LocationMatch "\""hsqldb"\"">
      #   Redirect 404 /
      #</LocationMatch>"'
      tmsh save sys config
      
tmos_declared:
  enabled: true
  icontrollx_trusted_sources: false
  icontrollx_package_urls:
    - https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.19.1/f5-appsvcs-3.19.1-1.noarch.rpm
  post_onboard_enabled: true
  post_onboard_commands:
    - /config/custom-config.sh
