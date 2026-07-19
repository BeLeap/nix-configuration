# Verify Pi Tor routing

The active Pi session had a bootstrapped Tor client listening on `127.0.0.1:63528`, and shell commands were launched with the expected torsocks environment and injected dylib.

End-to-end verification found that ordinary shell traffic was **not** reliably routed through Tor:

- `curl https://check.torproject.org/api/ip` returned `IsTor: false` and the normal public IP.
- Explicitly routing the same request with curl's `socks5h://127.0.0.1:63528` proxy support returned `IsTor: true` and a Tor exit IP.
- `DYLD_PRINT_LIBRARIES` confirmed that curl loaded `libtorsocks`, while torsocks debug output confirmed the configured Tor port, but torsocks did not intercept curl's network connection.

Conclusion: the Tor process and SOCKS endpoint work, but the extension's macOS torsocks/DYLD approach can silently leak direct traffic. The Pi Tor status indicator currently proves only that Tor is running, not that shell traffic is routed. Model-provider traffic is intentionally unaffected.
