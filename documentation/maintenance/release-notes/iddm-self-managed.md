---
title: RadiantOne IDDM Vulnerability Fixes
description: RadiantOne IDDM Vulnerability Fixes Release Notes
---

# RadiantOne Identity Data Management Vulnerability Fixes

April 14, 2026

These release notes detail important vulnerability fixes for container base images, including the latest operating system security patches 
as well as vulnerability updates related to third‑party libraries in RadiantOne Identity Data Management v8.3.2.


## Security Vulnerability Fixes


**CRITICAL (8)**

* CVE-2024-45337 – Authorization bypass in Go SSH `PublicKeyCallback` misuse
* CVE-2025-0306 – Timing channel allows decryption/signature forgery (Marvin Attack)
* CVE-2025-15467 – Stack buffer overflow in OpenSSL AEAD parameter parsing (DoS/RCE)
* CVE-2025-3277 – Integer overflow in SQLite `concat_ws()` leading to buffer write
* CVE-2026-29145 – CLIENT_CERT auth bypass in Apache Tomcat/Tomcat Native
* CVE-2026-32767 – Authorization bypass in SiYuan full-text search endpoint
* CVE-2026-33210 – Format string injection in Ruby JSON gem (DoS/info disclosure)
* CVE-2026-4176 – Unspecified critical vulnerability in Perl

**HIGH (71)**

* CVE-2014-3916 – DoS via long string in Ruby `str_buf_cat`
* CVE-2017-3204 – Go SSH missing host key verification (MITM)
* CVE-2020-29652 – Nil pointer dereference DoS in Go SSH server
* CVE-2020-7919 – Go crypto vulnerability affecting Helm
* CVE-2020-9283 – Panic via crafted ed25519 key in Go SSH
* CVE-2021-29923 – Go IP address octal misinterpretation allows ACL bypass
* CVE-2021-43565 – Panic via malformed packet in Go SSH (AES-GCM/ChaCha20)
* CVE-2022-21698 – DoS via unbounded label cardinality in Prometheus client_golang
* CVE-2022-24675 – Stack overflow in Go `encoding/pem` via large PEM data
* CVE-2022-27191 – SSH server crash when using non-AlgorithmSigner host key
* CVE-2022-28328 – Panic via long scalar in Go P256 ScalarMult
* CVE-2022-30636 – Windows path traversal in ACME DirCache token lookup
* CVE-2022-3064 – Excessive CPU/memory from malicious YAML in go-yaml
* CVE-2023-25151 – Unbounded metric cardinality in OpenTelemetry HTTP handler
* CVE-2023-45142 – Memory exhaustion via unbound labels in OpenTelemetry-Go
* CVE-2024-26141 – DoS via crafted Range headers in Rack
* CVE-2024-26146 – ReDoS in Rack header parsing (Accept/Forwarded)
* CVE-2024-41123 – DoS via special characters in REXML XML parsing
* CVE-2024-41946 – DoS via entity expansion in REXML SAX2/pull parser
* CVE-2024-43398 – DoS via deeply nested elements in REXML tree parser
* CVE-2024-47220 – HTTP request smuggling in Ruby WEBrick
* CVE-2024-49761 – ReDoS via hex numeric character references in REXML
* CVE-2024-53427 – Stack buffer overflow in jq `decNumberCopy` (NaN handling)
* CVE-2025-12183 – Out-of-bounds read in Zipkin
* CVE-2025-22869 – DoS via slow key exchange in Go SSH file transfer servers
* CVE-2025-22874 – Policy validation disabled when `ExtKeyUsageAny` used in Go TLS
* CVE-2025-27111 – Log injection via unsanitized `X-Sendfile-Type` header in Rack
* CVE-2025-27219 – Unspecified CGI vulnerability in Ruby (Alpine)
* CVE-2025-27610 – `Rack::Static` serves files outside configured `urls:` scope
* CVE-2025-29087 – SQLite `concat_ws()` memory write beyond malloc buffer
* CVE-2025-31498 – Unspecified vulnerability in c-ares (Alpine)
* CVE-2025-46727 – Unlimited parameter count in `Rack::QueryParser` (DoS)
* CVE-2025-47219 – Heap buffer over-read in GStreamer isomp4 MP4 parser
* CVE-2025-48060 – Heap buffer overflow in jq `jv_string_vfmt`
* CVE-2025-5244 – Memory corruption in GNU Binutils `elf_gc_sweep`
* CVE-2025-5245 – Memory corruption in GNU Binutils `debug_type_samep`
* CVE-2025-5399 – Unspecified curl vulnerability (Alpine)
* CVE-2025-6052 – Integer overflow in GLib GString memory management
* CVE-2025-61594 – URI credential leak bypass for CVE-2025-27221 in Ruby URI gem
* CVE-2025-61770 – Unbounded multipart preamble buffering in `Rack::Multipart::Parser`
* CVE-2025-61771 – Unbounded non-file form field memory in `Rack::Multipart::Parser`
* CVE-2025-61772 – Unbounded accumulation on unterminated multipart headers in Rack
* CVE-2025-61919 – Unbounded request body buffering in `Rack::Request#POST`
* CVE-2025-64720 – Out-of-bounds read in libpng `png_image_read_composite`
* CVE-2025-65018 – Heap buffer overflow in libpng simplified API
* CVE-2025-65637 – DoS in logrus when logging >64KB single-line payloads
* CVE-2025-66293 – Out-of-bounds read in libpng simplified API (pre-1.6.52)
* CVE-2025-66566 – Buffer disclosure via uncleared output in lz4-java decompressor
* CVE-2025-68119 – Local code execution via malicious Go module version strings (Mercurial)
* CVE-2025-69649 – Null pointer dereference in GNU Binutils `readelf` relocation processing
* CVE-2025-69650 – Double free in GNU Binutils `readelf` GOT relocation handling
* CVE-2025-69720 – Stack buffer overflow in ncurses `infocmp` tool
* CVE-2025-69873 – ReDoS in ajv `pattern` keyword validation
* CVE-2026-1584 – NULL pointer dereference via invalid PSK binder in GnuTLS TLS handshake
* CVE-2026-21710 – Uncaught exception DoS via `__proto__` header in Node.js HTTP
* CVE-2026-22695 – Unspecified libpng vulnerability (Wolfi)
* CVE-2026-22801 – Unspecified libpng vulnerability (Wolfi)
* CVE-2026-22860 – Directory traversal in `Rack::Directory` path prefix check
* CVE-2026-24880 – HTTP request smuggling via invalid chunk extension in Apache Tomcat
* CVE-2026-25646 – Out-of-bounds read in libpng `png_set_quantize()`
* CVE-2026-27820 – Buffer overflow in `zstream_buffer_ungets()`
* CVE-2026-33416 – Heap buffer alias/UAF in libpng `png_set_tRNS`/`png_set_PLTE`
* CVE-2026-33636 – Out-of-bounds read/write in libpng ARM Neon-optimized path
* CVE-2026-3441 – Heap buffer over-read in GNU Binutils BFD via crafted XCOFF
* CVE-2026-3442 – Heap buffer overflow in GNU Binutils BFD via crafted XCOFF
* CVE-2026-34483 – Output encoding vulnerability in Apache Tomcat `JsonAccessLogValve`
* CVE-2026-34487 – Kubernetes bearer token exposed in Apache Tomcat cloud clustering logs
* CVE-2026-34785 – `Rack::Static` serves files via string prefix match bypass
* CVE-2026-34827 – ReDoS in Rack multipart quoted parameter parsing
* CVE-2026-34829 – Unbounded multipart body read without Content-Length in Rack
* CVE-2026-35611 – ReDoS via URI template expansion in Ruby Addressable

**MEDIUM (84)**

* CVE-2013-0256 – XSS in RDoc darkfish.js (Ruby)
* CVE-2019-11254 – CPU exhaustion via malicious YAML in Kubernetes API Server
* CVE-2019-11840 – Incorrect XChaCha20Poly1305 output for >256 GiB keystream
* CVE-2019-11841 – Message forgery in Go OpenPGP cleartext signed messages
* CVE-2020-29509 – XML namespace prefix semantics bypass in Go `encoding/xml`
* CVE-2020-29511 – XML element namespace prefix bypass in Go `encoding/xml`
* CVE-2022-27943 – Unspecified libiberty vulnerability (GCC, Debian)
* CVE-2022-29526 – Incorrect privilege assignment in Go `Faccessat`
* CVE-2023-51774 – Identity check bypass in Ruby json-jwt via sign/encryption confusion
* CVE-2024-23337 – Integer overflow DoS in jq index assignment
* CVE-2024-25126 – ReDoS in Rack media type parser via crafted Content-Type
* CVE-2024-35176 – DoS via many `<` characters in REXML attribute value
* CVE-2024-39908 – DoS via special characters in REXML (pre-3.3.1)
* CVE-2024-45993 – Unspecified giflib vulnerability (Wolfi)
* CVE-2025-10148 – Unspecified curl vulnerability (Alpine)
* CVE-2025-11187 – Stack overflow/null dereference via missing PKCS#12 PBMAC1 validation
* CVE-2025-1153 – Unspecified binutils vulnerability (Alpine)
* CVE-2025-14762 – EDK instruction file parsing issue in S3 Encryption Client for Ruby
* CVE-2025-15468 – NULL dereference via unknown cipher suite in OpenSSL QUIC
* CVE-2025-15469 – Silent truncation of >16MB input in `openssl dgst` one-shot signing
* CVE-2025-24294 – DoS via crafted DNS packet in Ruby resolv gem
* CVE-2025-25184 – Log injection via newline characters in `Rack::CommonLogger`
* CVE-2025-27220 – ReDoS in Ruby CGI `Util#escapeElement`
* CVE-2025-27221 – Auth credential leak in Ruby URI `join`/`merge`/`+`
* CVE-2025-29088 – DoS via integer overflow in SQLite `sqlite3_db_config`
* CVE-2025-30258 – Signature verification broken via crafted subkey in GnuPG
* CVE-2025-3198 – Unspecified binutils vulnerability (Alpine)
* CVE-2025-32955 – Harden-Runner `disable-sudo` policy bypass
* CVE-2025-32989 – Heap buffer over-read in GnuTLS SCT extension parsing
* CVE-2025-43857 – DoS via memory exhaustion in Ruby `Net::IMAP` server response parsing
* CVE-2025-45582 – File overwrite via directory traversal in GNU Tar archive extraction
* CVE-2025-49007 – DoS in Rack Content-Disposition parsing
* CVE-2025-4947 – QUIC/IP connection skips certificate verification in libcurl
* CVE-2025-5025 – Certificate public key pinning not enforced for QUIC/wolfSSL in libcurl
* CVE-2025-58457 – Insufficient permission checks for `snapshot`/`restore` in AdminServer
* CVE-2025-58767 – XML entity expansion DoS in Ruby REXML
* CVE-2025-6141 – Stack buffer overflow in ncurses `postprocess_termcap`
* CVE-2025-61780 – Information disclosure via miscommunication in `Rack::Sendfile`
* CVE-2025-62408 – Unspecified c-ares vulnerability (Alpine)
* CVE-2025-6442 – HTTP request smuggling in Ruby WEBrick `read_header`
* CVE-2025-64505 – Heap buffer over-read in libpng `png_do_quantize`
* CVE-2025-64506 – Heap buffer over-read in libpng `png_write_image_8bit`
* CVE-2025-66199 – Memory exhaustion via TLS 1.3 certificate compression in OpenSSL
* CVE-2025-67735 – CRLF injection in Netty `HttpRequestEncoder` URI
* CVE-2025-68972 – Signature verification bypass via `\f` in GnuPG signed messages
* CVE-2025-69644 – DoS via malformed DWARF in GNU Binutils `objdump`
* CVE-2025-69647 – Infinite loop via malformed DWARF loclists in `readelf`
* CVE-2025-69648 – Infinite loop via malformed DWARF rnglists in `readelf`
* CVE-2025-69651 – Invalid pointer free in `readelf` relocation parsing
* CVE-2025-69652 – SIGABRT via malformed DWARF abbrev in `readelf`
* CVE-2025-9231 – Timing side-channel in SM2 signature on ARM64 (OpenSSL)
* CVE-2025-9232 – Out-of-bounds read via IPv6 in OpenSSL HTTP `no_proxy` handling
* CVE-2026-21713 – Timing side-channel in Node.js HMAC validation (`memcmp`)
* CVE-2026-21714 – Memory exhaustion via HTTP/2 flow control window overflow in Node.js
* CVE-2026-21715 – Missing authorization via `fs.realpathSync.native()` in Node.js
* CVE-2026-21717 – Hash collision DoS via integer-like strings in Node.js V8
* CVE-2026-25500 – XSS in `Rack::Directory` HTML index via special filename
* CVE-2026-25598 – Harden-Runner logging bypass via `sendto`/`sendmsg`/`sendmmsg`
* CVE-2026-25765 – Auth credential leak in Faraday `build_exclusive_url` via URI merge
* CVE-2026-25854 – Open redirect in Apache Tomcat `LoadBalancerDrainingValve`
* CVE-2026-26962 – Embedded CRLF in folded multipart headers in Rack
* CVE-2026-27456 – TOCTOU race in `util-linux` SUID mount binary loop device setup
* CVE-2026-32762 – Rack `Forwarded` header parsed incorrectly due to quoted semicolons
* CVE-2026-32776 – NULL pointer dereference in libexpat empty external parameter entity
* CVE-2026-32777 – Infinite loop in libexpat DTD parsing
* CVE-2026-32778 – Unspecified libexpat vulnerability (Alpine)
* CVE-2026-32946 – Harden-Runner egress policy bypass via DNS over TCP
* CVE-2026-32947 – Harden-Runner egress policy bypass via DNS over HTTPS
* CVE-2026-33169 – ReDoS via long digit strings in Rails `NumberToDelimitedConverter`
* CVE-2026-33170 – `SafeBuffer#%` drops HTML-unsafe flag in Rails Active Support
* CVE-2026-33176 – DoS via scientific notation strings in Rails number helpers
* CVE-2026-34230 – Quadratic time complexity in `Rack::Utils.select_best_encoding` via wildcard Accept-Encoding
* CVE-2026-34500 – CLIENT_CERT auth bypass with FFM in Apache Tomcat
* CVE-2026-34757 – Aliased buffer use-after-free in libpng `png_set_PLTE`/`png_set_tRNS`
* CVE-2026-34763 – Regex metacharacter injection in `Rack::Directory` root path
* CVE-2026-34786 – URL-encoded path bypass in `Rack::Static` rule matching
* CVE-2026-34826 – Unlimited byte range count in `Rack::Utils.get_byte_ranges` (DoS)
* CVE-2026-34830 – Regex injection via `X-Accel-Mapping` header in `Rack::Sendfile`
* CVE-2026-34831 – Incorrect `Content-Length` for multibyte UTF-8 in `Rack::Files`
* CVE-2026-34835 – Non-RFC characters accepted in Host header by `Rack::Request`
* CVE-2026-4647 – Improper relocation type handling in GNU Binutils BFD (XCOFF)
* CVE-2026-4878 – TOCTOU race in `cap_set_file()` in libcap
* CVE-2026-5704 – Hidden file injection via crafted TAR archive in tar

**LOW (18)**

* CVE-2005-2541 – Tar doesn't warn on setuid/setgid file extraction
* CVE-2007-5686 – Insecure `/var/log/btmp` permissions leaking auth attempts
* CVE-2010-0928 – Weak RSA signature in OpenSSL on FPGA hardware
* CVE-2011-3374 – GPG key validation bypass in apt-key (MITM risk)
* CVE-2011-4116 – Symlink handling flaw in Perl `File::Temp`
* CVE-2017-18018 – Race condition in `chown`/`chgrp` with `-R -L` allows ownership manipulation
* CVE-2022-0563 – Info disclosure via INPUTRC env variable in util-linux `chfn`/`chsh`
* CVE-2022-3219 – DoS via large key with many signatures in GnuPG
* CVE-2024-52587 – Command injection in Harden-Runner `setup.ts`/`arc-runner.ts`
* CVE-2024-56433 – Default `/etc/subuid` UID range conflicts with network user UIDs in shadow-utils
* CVE-2025-5278 – Heap buffer under-read in GNU Coreutils `sort` `begfield()`
* CVE-2026-1225 – ACE via logback config file class instantiation
* CVE-2026-21716 – Incomplete fix for CVE-2024-36137; missing permission checks in Node.js `FileHandle.chmod()`/`chown()`
* CVE-2026-21947 – Oracle Java SE JavaFX network vulnerability
* CVE-2026-24515 – libexpat unknown encoding handler user data not copied
* CVE-2026-24733 – Apache Tomcat HTTP/0.9 not restricted to GET method
* CVE-2026-26961 – ReDoS in Rack multipart boundary extraction
* CVE-2026-3184 – Hostname canonicalization manipulation in `util-linux login -h`
