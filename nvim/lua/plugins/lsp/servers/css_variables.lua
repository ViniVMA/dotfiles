return {
  filetypes = { "css", "scss", "less", "vue" },
  settings = {
    cssVariables = {
      lookupFiles = {
        "**/*.less",
        "**/*.scss",
        "**/*.sass",
        "**/*.css",
        "**/node_modules/@superbet-group/web.lib.global-styles/**/*.css",
        "**/node_modules/@superbet-group/web.lib.global-styles/**/*.scss",
        "**/node_modules/@superbet-group/web.lib.ui-tokens/**/*.css",
        "**/node_modules/@superbet-group/web.lib.ui-tokens/**/*.scss",
      },
      blacklistFolders = {
        "**/.cache",
        "**/.DS_Store",
        "**/.git",
        "**/.hg",
        "**/.next",
        "**/.svn",
        "**/bower_components",
        "**/CVS",
        "**/dist",
        "**/tmp",
      },
    },
  },
}
