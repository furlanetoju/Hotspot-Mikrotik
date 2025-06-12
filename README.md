# Criando hotspot Mikrotik

1° Vamos criar a nossa bridge cliente e associar as interfaces as mesmas.

2° Depois definimos uma faixa de IP local e adicionamos a nossa bridge-clientes.

3° Pomos iniciar a configuração do hostspot. 

Vamos em IP Hotspot e podemos iniciar no assistente clicando em "Hotspot Setup", vamos em next- next. Até concluir. É importante lembrar que demos selecionar nossa rede bridge ok.

Temos a opção de criar um trial para o cliente testar a conexão por um determinado tempo, para isso, vamos em Server Profile>Login
E vamos marcar as box de MAC e Trial
Quando marcamos essas duas opções, logo abaixo vai nos permitir editar o tempo do trial.

Caso queira permitir acesso a um site, mesmo se o cliente não estiver autenticado pelo hotspot, podemos usar a opção Walled Garden do Hostpot.

Exemplo de configuração:


```
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

```

