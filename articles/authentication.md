# Authenticating with the Cloudflare API

cloudflarer supports both Cloudflare authentication schemes:

1.  **API token** (recommended) – a scoped credential created in the
    dashboard, sent as `Authorization: Bearer <token>`.
2.  **Global API Key** (legacy) – the unscoped account key paired with
    your email address, sent as `X-Auth-Email` and `X-Auth-Key` headers.

The package picks the mode automatically from the environment.
\[[`cf_auth_mode()`](http://drmowinckels.io/cloudflarer/reference/cf_auth_mode.md)\]
tells you which one is active, and
\[[`cf_sitrep()`](http://drmowinckels.io/cloudflarer/reference/cf_sitrep.md)\]
confirms that the configured credentials work.

If both are configured, the API token wins because it is the modern,
scoped option.

## API token (recommended)

API tokens let you grant least-privilege access for a single script or
service. Use them whenever possible.

### Create a token

1.  Sign in at <https://dash.cloudflare.com/>.
2.  Open <https://dash.cloudflare.com/profile/api-tokens>.
3.  Click **Create Token**.
4.  Pick a template (for example **Read all resources**) or **Create
    Custom Token** for fine-grained scope control.
5.  Confirm the **Account Resources** and **Zone Resources** that the
    token should apply to.
6.  Click **Continue to summary**, then **Create Token**.
7.  Copy the token shown on the confirmation page. Cloudflare only
    displays it once.

### Store the token

Add it to `~/.Renviron` so it loads with every R session:

    CLOUDFLARE_API_TOKEN=your-token-here

For ad-hoc use, set it inline:

``` r

Sys.setenv(CLOUDFLARE_API_TOKEN = "your-token-here")
```

`usethis::edit_r_environ()` is a convenient way to open `~/.Renviron`
from RStudio.

## Global API Key (legacy)

The Global API Key has full account privileges and cannot be scoped.
Prefer API tokens; reach for the Global API Key only when you genuinely
need an endpoint that does not yet accept tokens, or when you are
quickly experimenting.

### Find the key

1.  Open <https://dash.cloudflare.com/profile/api-tokens>.
2.  In the **API Keys** section, click **View** next to **Global API
    Key**.
3.  Confirm your password and copy the key.

### Store the credentials

Both the email and the key are required:

    CLOUDFLARE_EMAIL=you@example.com
    CLOUDFLARE_API_KEY=your-global-api-key

Make sure `CLOUDFLARE_API_TOKEN` is unset (or empty) if you want the
package to use the key path – the token takes precedence otherwise.

## Verify the credentials

``` r

library(cloudflarer)

cf_auth_mode()
cf_has_auth()
cf_sitrep()
```

[`cf_sitrep()`](http://drmowinckels.io/cloudflarer/reference/cf_sitrep.md)
reports the package version, which auth mode is active, and the result
of an authenticated call against the live API (`/user/tokens/verify` for
tokens; `/user` for the Global API Key).

To inspect the verification response directly:

``` r

cf_verify()
```

A successful token response looks like:

    $id
    [1] "ed17574386854bf78a67040be0a770b0"

    $status
    [1] "active"

A successful Global API Key response is the `/user` payload:

    $id
    [1] "abc123..."

    $email
    [1] "you@example.com"

    $organizations
    list()

## Per-call credentials

Every function that talks to the API accepts `token`, `email`, and
`api_key` arguments. This is useful when juggling multiple credentials
or running in environments where the env vars cannot be set:

``` r

cf_list_zones(token = Sys.getenv("CLOUDFLARE_RO_TOKEN"))

cf_user(
  email   = "you@example.com",
  api_key = Sys.getenv("CLOUDFLARE_API_KEY")
)
```

An explicit `token` always wins; otherwise explicit `email` + `api_key`
wins; otherwise the environment is consulted.

## Troubleshooting

- `No Cloudflare credentials found.` – neither `CLOUDFLARE_API_TOKEN`
  nor the `CLOUDFLARE_EMAIL` + `CLOUDFLARE_API_KEY` pair is set. Add one
  and restart R.
- `Cloudflare API request failed.` with `code 1000` – the token or key
  is invalid. Recreate it in the dashboard.
- `code 6003` – the credential format is malformed. Common cause: stray
  whitespace or quote characters in `~/.Renviron`.
- `code 9109` – the token lacks the permissions the endpoint needs. Edit
  the token in the dashboard and add the required scope. The Global API
  Key always has full access, so seeing this on the key path is unusual.

## Never commit credentials

Tokens and keys grant access to your Cloudflare account. Keep them out
of source control. `~/.Renviron` is a good default; for CI/CD, use the
platform’s secret store.
