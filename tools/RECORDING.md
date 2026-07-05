# Recording vcr cassettes for examples and vignettes

The examples and vignettes make live Cloudflare API calls. To let them
run offline in CI and `R CMD check`, their HTTP interactions are
replayed from [`vcr`](https://docs.ropensci.org/vcr/) cassettes. The
cassettes are recorded once, against a real account, then committed and
replayed forever after.

This is a two-step flow: **record** (needs your credentials, done
locally) then **flip** (drop `\dontrun{}` / `eval = FALSE` and add the
cassette wrappers). Until you record, examples stay in `\dontrun{}` and
vignettes stay `eval = FALSE`, so the check stays green.

## 1. Record

With valid credentials in your environment (`CLOUDFLARE_API_TOKEN`, or
`CLOUDFLARE_EMAIL` + `CLOUDFLARE_API_KEY`):

```sh
Rscript tools/record-cassettes.R
```

This discovers your first account and zone, exercises each documented
call inside a named cassette, and writes YAML to `inst/_vcr/` (examples)
and `vignettes/_vcr/` (vignettes). Real identifiers, tokens, emails, and
keys are scrubbed to the placeholders the examples use (`abc123`,
`acc-1`, `<<TOKEN>>`, ...), so nothing account-specific is committed.

Re-record after an API change with `RECORD=all Rscript
tools/record-cassettes.R`.

Inspect the generated cassettes before committing. Then run the script a
second time — vcr should replay cleanly, confirming the cassettes work.

## 2. Flip

Once the cassettes exist, switch the examples and vignettes from
illustrative to executed.

### Examples

Replace the `\dontrun{}` wrapper with an `insert_example_cassette()` /
`eject_cassette()` pair hidden in `\dontshow{}`. The cassette name is the
file stem under `inst/_vcr/` (see `tools/record-cassettes.R` for the
names).

Before:

```r
#' @examples
#' \dontrun{
#' cf_get_zone("abc123")
#' }
```

After:

```r
#' @examples
#' \dontshow{vcr::insert_example_cassette("cf_get_zone", package = "cloudflarer")}
#' cf_get_zone("abc123")
#' \dontshow{vcr::eject_cassette()}
```

The example must use the same placeholder identifiers the cassette was
scrubbed to (`"abc123"` for a zone, `"acc-1"` for an account), or the
replay will not match the recorded request URI.

`insert_example_cassette()` records (`record = "once"`) when run from the
source tree and replays (`record = "none"`) from the installed package,
so a missing cassette fails the check loudly rather than calling the
network.

### Vignettes

In the setup chunk, drop `eval = FALSE`, set a placeholder token, and
enable the knitr hook:

```r
#| label: setup
#| include: false
library(cloudflarer)
library(vcr)
Sys.setenv(CLOUDFLARE_API_TOKEN = "<<TOKEN>>")
vcr::vcr_configure(dir = "_vcr", filter_request_headers = "Authorization")
vcr::setup_knitr()
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
```

Then tag each chunk that performs HTTP with the matching cassette name:

````
```{r}
#| cassette: intro-discover
cf_user()
cf_list_accounts()
cf_list_zones()
```
````

Chunks that only manipulate already-fetched data (subsetting, `head()`,
`tryCatch()` over an in-memory object) need no cassette.

## 3. Verify

```sh
Rscript -e 'devtools::check(args = c("--no-manual", "--as-cran"))'
```

Examples and vignettes now execute against the cassettes; the check
should stay `0 errors, 0 warnings, 0 notes`.
