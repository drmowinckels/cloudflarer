#' Cloudflare situation report
#'
#' Prints a short summary of the package version, which auth mode
#' is configured ([cf_auth_mode()]), and whether the configured
#' credentials successfully authenticate against the Cloudflare API.
#' Use this as a first stop when debugging configuration issues.
#'
#' @return Invisibly, a list with the diagnostic results.
#' @export
#' @family authentication
#' @examples
#' cf_sitrep()
cf_sitrep <- function() {
  cli::cli_h1("cloudflarer sitrep")
  version <- utils::packageVersion("cloudflarer")
  cli::cli_alert_info("Package version: {.val {version}}")

  mode <- cf_auth_mode()
  if (is.na(mode)) {
    cli::cli_alert_danger(
      "No Cloudflare credentials found in the environment."
    )
    cli::cli_alert_info(paste(
      "Set {.envvar CLOUDFLARE_API_TOKEN}, or both",
      "{.envvar CLOUDFLARE_EMAIL} and {.envvar CLOUDFLARE_API_KEY}."
    ))
    return(invisible(list(
      version = version,
      auth_mode = NA_character_,
      verified = FALSE,
      verification = NULL
    )))
  }

  if (mode == "token") {
    cli::cli_alert_success("Using API token ({.envvar CLOUDFLARE_API_TOKEN}).")
  } else {
    cli::cli_alert_success(
      "Using Global API Key ({.envvar CLOUDFLARE_EMAIL} + {.envvar CLOUDFLARE_API_KEY})."
    )
    cli::cli_alert_info(
      "Prefer a scoped API token via {.envvar CLOUDFLARE_API_TOKEN}."
    )
  }

  verification <- tryCatch(
    cf_verify(),
    error = function(e) {
      cli::cli_alert_danger(
        "Credential verification failed: {.val {conditionMessage(e)}}"
      )
      NULL
    }
  )
  if (!is.null(verification)) {
    cli::cli_alert_success("Credentials verified against the Cloudflare API.")
  }

  invisible(list(
    version = version,
    auth_mode = mode,
    verified = !is.null(verification),
    verification = verification
  ))
}
