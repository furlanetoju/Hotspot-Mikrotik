# jun/12/2025 16:12:22 by RouterOS 6.49.13
# software id = FWTG-B1WT
#
# model = RouterBOARD 941-2nD
# serial number = 661607E29AB5
/interface bridge
add name=bridge-hotspot
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no frequency=auto \
    mode=ap-bridge ssid=MikroTik-Hotspot
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
set [ find default=yes ] html-directory=hotspot/lv
/ip hotspot user profile
add name=Trial
/ip hotspot profile
add dns-name=trial.varzeanet.com.br hotspot-address=100.64.0.1 login-by=\
    http-pap,trial,mac-cookie name=hsprof1 trial-uptime-limit=30s \
    trial-user-profile=Trial
/ip pool
add name=hs-pool-6 ranges=100.64.0.2-100.64.0.254
/ip dhcp-server
add address-pool=hs-pool-6 disabled=no interface=bridge-hotspot lease-time=1h \
    name=dhcp1
/ip hotspot
add address-pool=hs-pool-6 disabled=no interface=bridge-hotspot name=hotspot1 \
    profile=hsprof1
/interface bridge port
add bridge=bridge-hotspot interface=wlan1
/ip address
add address=172.16.0.144/24 interface=ether2 network=172.16.0.0
add address=100.64.0.1/24 interface=bridge-hotspot network=100.64.0.0
/ip dhcp-server network
add address=100.64.0.0/24 comment="hotspot network" gateway=100.64.0.1
/ip dns
set servers=8.8.8.8
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=100.64.0.0/24
/ip hotspot user
add name=admin
/ip hotspot walled-garden
add dst-host=varzeanet.com.br server=hotspot1
add dst-host=faturas.varzeanet.com.br server=hotspot1
/ip route
add distance=1 gateway=172.16.0.254
/system clock
set time-zone-name=America/Sao_Paulo
