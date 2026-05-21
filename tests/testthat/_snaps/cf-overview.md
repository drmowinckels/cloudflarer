# cf_zone_overview() / snapshots cleanly when printed

    Code
      print(ov)
    Message
      
      -- Zone overview ---------------------------------------------------------------
      i Window: "2026-05-19" to "2026-05-21"
      
      > Requests:        "3,000"
      > Page views:      "300"
      > Uniques:         "150"
      > Bandwidth:       "143.1 MB"
      > Threats:         "15"
      > Cache hit (req): "73.3%"
      > Cache hit (BW):  "73.3%"
      > DNS queries:     "12,500"
      > Firewall events: not available (Pro+ feature)
      
      i Use `$traffic`, `$cache`, `$dns`, `$firewall`, `$top_countries` for per-day breakdowns.

# cf_zone_overview() / snapshots both firewall and top_countries when present

    Code
      print(ov)
    Message
      
      -- Zone overview ---------------------------------------------------------------
      i Window: "2026-05-20" to "2026-05-21"
      
      > Requests:        "100"
      > Page views:      "10"
      > Uniques:         "5"
      > Bandwidth:       "0.0 MB"
      > Threats:         "1"
      > Cache hit (req): "50.0%"
      > Cache hit (BW):  "50.0%"
      > DNS queries:     "200"
      > Firewall events: "7"
      
      -- Top countries (RUM) --
      
      >   Norway: 100
      >   Sweden: 50
      >   Germany: 25
      
      i Use `$traffic`, `$cache`, `$dns`, `$firewall`, `$top_countries` for per-day breakdowns.

