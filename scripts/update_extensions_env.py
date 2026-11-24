#!/usr/bin/env python3
"""Generate extensions.env from docker-php-extension-installer support table.

Usage:
  python3 scripts/update_extensions_env.py              # all PHP versions -> extensions.env
  python3 scripts/update_extensions_env.py 8.3          # single version
  python3 scripts/update_extensions_env.py 8.3 out.env
"""
import os, sys, urllib.request

URL = "https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/README.md"
PHP_COLS = ["PHP 8.6","PHP 8.5","PHP 8.4","PHP 8.3","PHP 8.2","PHP 8.1","PHP 8.0",
            "PHP 7.4","PHP 7.3","PHP 7.2","PHP 7.1","PHP 7.0","PHP 5.6","PHP 5.5"]

def main():
    out = sys.argv[2] if len(sys.argv) > 2 else "extensions.env"
    versions = [sys.argv[1]] if len(sys.argv) > 1 else [v.replace("PHP ","") for v in PHP_COLS]
    md = urllib.request.urlopen(URL).read().decode()
    start = md.index("| Extension |")
    end = md.index("*Number of supported extensions")
    table = md[start:end]
    rows = []
    for line in table.splitlines():
        if not line.strip().startswith("|") or "---" in line or "Extension" in line.split("|")[1]:
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) < 2: continue
        rows.append((cells[0].split("[")[0].strip(), cells[1:]))
    with open(out, "w") as f:
        for ver in versions:
            col = "PHP " + ver
            assert col in PHP_COLS, f"unknown version {ver}"
            idx = PHP_COLS.index(col)
            exts = [name for name, cells in rows if idx < len(cells) and cells[idx] == "&check;"]
            key = "PHP_" + ver.replace(".", "_") + "_EXTENSIONS"
            f.write(f"# PHP {ver} supported extensions (docker-php-extension-installer)\n")
            f.write(f"{key}=" + " ".join(exts) + "\n")
            print(f"PHP {ver}: {len(exts)} extensions")
    print(f"wrote {out}")

if __name__ == "__main__":
    main()
