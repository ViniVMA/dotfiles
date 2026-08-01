return {
  "teocns/neocursor.nvim",
  event = "InsertEnter",
  build = 'uv run --with "httpx[http2]" python -c "import httpx"',
  opts = {
    map_tab = false,
    show_hints = false,
    sidecar_cmd = { "uv", "run", "--with", "httpx[http2]", "--python", "3" },
  },
}
