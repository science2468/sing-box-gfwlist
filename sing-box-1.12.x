{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "dns": {
    "servers": [
      {
        "tag": "dns_local",
        "type": "udp",
        "server": "223.5.5.5"
      },
      {
        "tag": "dns_proxy",
        "type": "udp",
        "server": "1.1.1.1"
      }
    ],
    "rules": [
      {
        "rule_set": [
          "geosite-gfw"
        ],
        "server": "dns_proxy"
      }
    ],
    "final": "dns_local"
  },
  "endpoints": [
    {
      "type": "wireguard",
      "tag": "warp-out",
      "system": false,
      "mtu": 1280,
      "address": [
        "172.16.0.2/32",
        "2606:4700:110:8e03:8244:d889:bb7f:c258/128"
      ],
      "private_key": "+PsuRotO4oJl0v9zKVztgWEQoKz8iEvl5csC2+aoblM=",
      "peers": [
        {
          "address": "[2606:4700:100::a29f:c102]",
          "port": 500,
          "public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
          "allowed_ips": [
            "0.0.0.0/0",
            "::/0"
          ],
          "persistent_keepalive_interval": 30
        }
      ],
      "domain_resolver": "dns_proxy"
    }
  ],
  "inbounds": [
    {
      "type": "mixed",
      "tag": "mixed-in",
      "listen": "127.0.0.1",
      "listen_port": 10800,
      "set_system_proxy": true
    }
  ],
  "outbounds": [
    {
      "type": "selector",
      "tag": "select",
      "outbounds": [
        "warp-out",
        "hk-out"
      ],
      "default": "hk-out",
      "interrupt_exist_connections": true
    },
    {
      "type": "shadowsocks",
      "tag": "hk-out",
      "server": "103.149.182.191",
      "server_port": 8388,
      "method": "chacha20-ietf",
      "password": "asd123456",
      "domain_resolver": "dns_proxy"
    },
    {
      "type": "direct",
      "tag": "direct-out",
      "domain_resolver": "dns_local"
    }
  ],
  "route": {
    "rules": [
      {
        "inbound": "tun-in",
        "action": "sniff"
      },
      {
        "protocol": "dns",
        "action": "hijack-dns"
      },
      {
        "rule_set": [
          "geosite-category-ads"
        ],
        "action": "reject",
        "outbound": "direct-out"
      },
      {
        "domain": [
          "titles.prod.mos.microsoft.com // Microsoft Outlook for Copilot"
        ],
        "outbound": "select"
      },
      {
        "rule_set": [
          "geosite-gfw",
          "geoip-telegram"
        ],
        "outbound": "select"
      }
    ],
    "rule_set": [
      {
        "tag": "geosite-category-ads",
        "type": "remote",
        "format": "binary",
        "url": "https://cdn.jsdelivr.net/gh/1715173329/sing-geosite@rule-set/geosite-category-ads.srs",
        "download_detour": "direct-out"
      },
      {
        "tag": "geoip-telegram",
        "type": "remote",
        "format": "binary",
        "url": "https://cdn.jsdelivr.net/gh/1715173329/sing-geoip@rule-set/geoip-telegram.srs",
        "download_detour": "direct-out"
      },
      {
        "tag": "geosite-gfw",
        "type": "remote",
        "format": "binary",
        "url": "https://cdn.jsdelivr.net/gh/1715173329/sing-geosite@rule-set/geosite-gfw.srs",
        "download_detour": "direct-out"
      }
    ],
    "final": "direct-out",
    "auto_detect_interface": true
  },
  "experimental": {
    "cache_file": {
      "enabled": true,
      "path": "",
      "cache_id": ""
    },
    "clash_api": {
      "external_controller": "127.0.0.1:9090",
      "external_ui": "C:/Users/DXB24/Documents/sing-box/Yacd-meta-gh-pages/",
      "external_ui_download_url": "https://github.com/MetaCubeX/Yacd-meta/archive/gh-pages.zip",
      "external_ui_download_detour": "direct-out"
    }
  }
}