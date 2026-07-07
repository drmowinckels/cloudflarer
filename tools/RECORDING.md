# vcr cassettes for examples and vignettes

The examples and vignettes make live Cloudflare API calls, so they are
replayed offline from [`vcr`](https://docs.ropensci.org/vcr/) cassettes
during CI and `R CMD check`.

## The cassettes are synthetic and hand-maintained

The committed cassettes under `inst/_vcr/` (examples) and
`vignettes/_vcr/` (vignettes) hold **synthetic** data — `example.com`,
`192.0.2.x`, placeholder ids like `abc123` / `acc-1`. Nothing
account-specific ships. This is deliberate: the repo is public and
CRAN-bound, and real fixtures would leak zone names, DNS records, IPs,
and Email Routing **destination addresses (PII)**.

To add or change a cassette, edit the YAML by hand. The shape is a list
of `http_interactions`, each a `request` (`method` + `uri`) and a
`response` with a JSON `body.string`; copy an existing file. The `uri`
must match exactly what the wrapper builds (paginated list endpoints
append `?<filters>&per_page=<n>&page=1`); POST/PATCH match on method +
uri only. After editing, confirm it replays:

```r
devtools::run_examples()                 # examples, credentials unset
rmarkdown::render("vignettes/<name>.Rmd") # a vignette
```

A cassette that does not match the request fails loudly (`R CMD check`
errors), so mismatches never pass silently.

## Wiring

- **Examples** use `vcr::insert_example_cassette("<fn>", package =
"cloudflarer")` / `vcr::eject_cassette()` inside `\dontshow{}` (see any
  exported function). The cassette file stem is the function name.
- **Vignettes** call `vcr::setup_knitr(prefix = "")` in their setup chunk
  (shared in `vignettes/_vcr-setup.R`); each HTTP chunk sets a `cassette`
  option naming its `vignettes/_vcr/<name>.yml`.

## Optional: recording real fixtures

`tools/record-cassettes.R` can record against your live account **as a
starting point only**. It writes to `tools/_recorded/` (git-ignored) and
never touches the committed cassettes. Its output contains real account
data including PII — **scrub every real value to a synthetic placeholder
before copying anything into `inst/_vcr/` or `vignettes/_vcr/`.**

```sh
Rscript tools/record-cassettes.R
```
