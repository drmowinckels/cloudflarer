# cf_sitrep() / reports a missing credential

    Code
      res <- cf_sitrep()
    Message
      
      -- cloudflarer sitrep ----------------------------------------------------------
      i Package version: 0.0.0.9000
      x No Cloudflare credentials found in the environment.
      i Set `CLOUDFLARE_API_TOKEN`, or both `CLOUDFLARE_EMAIL` and `CLOUDFLARE_API_KEY`.

# cf_sitrep() / reports token auth and a verified credential

    Code
      res <- cf_sitrep()
    Message
      
      -- cloudflarer sitrep ----------------------------------------------------------
      i Package version: 0.0.0.9000
      v Using API token (`CLOUDFLARE_API_TOKEN`).
      v Credentials verified against the Cloudflare API.

# cf_sitrep() / reports key auth and a verified credential

    Code
      res <- cf_sitrep()
    Message
      
      -- cloudflarer sitrep ----------------------------------------------------------
      i Package version: 0.0.0.9000
      v Using Global API Key (`CLOUDFLARE_EMAIL` + `CLOUDFLARE_API_KEY`).
      i Prefer a scoped API token via `CLOUDFLARE_API_TOKEN`.
      v Credentials verified against the Cloudflare API.

# cf_sitrep() / reports verification failure without aborting

    Code
      res <- cf_sitrep()
    Message
      
      -- cloudflarer sitrep ----------------------------------------------------------
      i Package version: 0.0.0.9000
      v Using API token (`CLOUDFLARE_API_TOKEN`).
      x Credential verification failed: "nope"

