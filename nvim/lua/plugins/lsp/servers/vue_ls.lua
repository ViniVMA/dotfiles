return {
  enabled = true,
  init_options = {
    vue = {
      hybridMode = true,
    },
  },
  settings = {
    vue = {
      inlayHints = {
        missingProps = true,
        inlineHandlerLeading = true,
        optionsWrapper = true,
      },
      complete = {
        casing = {
          tags = "autoKebab",
        },
      },
    },
  },
}
