{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "dns": {
    "servers": [
      {
        "tag": "dns_local",
        "address": "223.5.5.5",
        "detour": "direct-out"
      },
      {
        "tag": "dns_proxy",
        "address": "tcp://1.1.1.1",
        "detour": "select"
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
      "tag": "team-out",
      "system": false,
      "mtu": 1280,
      "address": [
        "172.16.0.2/32",
        "2606:4700:110:8e03:8244:d889:bb7f:c258/128"
      ],
      "private_key": "+PsuRotO4oJl0v9zKVztgWEQoKz8iEvl5csC2+aoblM=",
      "peers": [
        {
          "address": "162.159.198.2",
          "port": 443,
          "public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
          "allowed_ips": [
            "0.0.0.0/0",
            "::/0"
          ],
          "persistent_keepalive_interval": 30
        }
      ]
    }
  ],
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "address": [
        "172.18.0.1/30",
        "fdfe:dcba:9876::1/126"
      ],
      "mtu": 9000,
      "auto_route": true,
      "strict_route": true
    }
  ],
  "outbounds": [
    {
      "type": "selector",
      "tag": "select",
      "outbounds": [
        "team-out",
        "warp-out",
        "ss-out"
      ],
      "default": "vmess-out"
    },
    {
      "type": "socks",
      "tag": "warp-out",
      "server": "192.168.1.101",
      "server_port": 1080
    },
    {
      "type": "shadowsocks",
      "tag": "ss-out",
      "server": "104.168.1.81",
      "server_port": 11144,
      "method": "2022-blake3-aes-256-gcm",
      "password": "t/8e49p03eA/0Bb7JG7Q2UTptOgGtaDALu03vpRHSJA="
    },
    {
      "type": "direct",
      "tag": "direct-out"
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
          "mss.office.com // IOS M365 Copilot",
          ""
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
  }
}