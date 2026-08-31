#!/usr/bin/env python3
"""Static integrity checks for the Power BI Vibes framework repository."""
from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED = [
    "AGENTS.md",
    "BOOTSTRAP.md",
    "CHANGELOG.md",
    "README.md",
    "START-HERE.md",
    "THIRD_PARTY_NOTICES.md",
    "UPSTREAM.lock.yml",
    "VERSION",
    "docs/Power-BI-Vibes-Guide.md",
    "docs/Power-BI-Vibes-Guide.pdf",
    "docs/build_guide.py",
    "framework/DATA.md",
    "framework/GIT.md",
    "framework/LEARNING.md",
    "framework/MICROSOFT-POWERBI.md",
    "framework/OPERATING-RULES.md",
    "framework/PRIVACY.md",
    "framework/QA.md",
    "framework/UPDATES.md",
    "prompts/BOOTSTRAP.txt",
    "prompts/RESUME.txt",
    "prompts/UPDATE.txt",
    "scripts/inspect-source.ps1",
    "templates/client/.gitattributes",
    "templates/client/.gitignore",
    "templates/client/AGENTS.md",
    "templates/client/README.md",
    "templates/client/acceptance.md",
    "templates/client/data-contract.yml",
    "templates/client/decisions.md",
    "templates/client/learning.yml",
    "templates/client/manifest.yml",
    "templates/client/report-spec.md",
]

MARKDOWN = [p for p in REQUIRED if p.endswith(".md")]
YAML_FILES = [
    "UPSTREAM.lock.yml",
    "templates/client/data-contract.yml",
    "templates/client/learning.yml",
    "templates/client/manifest.yml",
]


def fail(message: str) -> None:
    print(f"ERROR: {message}")
    global failures
    failures += 1


def check_files() -> None:
    for rel in REQUIRED:
        path = ROOT / rel
        if not path.is_file():
            fail(f"missing required file: {rel}")
        elif path.stat().st_size == 0:
            fail(f"required file is empty: {rel}")


def check_versions() -> None:
    version = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        fail(f"VERSION is not semantic x.y.z: {version!r}")
        return
    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    changelog = (ROOT / "CHANGELOG.md").read_text(encoding="utf-8")
    if f"`v{version}`" not in readme and f"v{version}" not in readme:
        fail(f"README does not mention current version {version}")
    if f"## {version} -" not in changelog:
        fail(f"CHANGELOG has no section for current version {version}")


def check_markdown_links() -> None:
    link_re = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
    for rel in MARKDOWN:
        src = ROOT / rel
        text = src.read_text(encoding="utf-8")
        for target in link_re.findall(text):
            target = target.split("#", 1)[0].strip()
            if not target or re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*://", target) or target.startswith("mailto:"):
                continue
            resolved = (src.parent / target).resolve()
            try:
                resolved.relative_to(ROOT.resolve())
            except ValueError:
                fail(f"{rel}: relative link leaves repository: {target}")
                continue
            if not resolved.exists():
                fail(f"{rel}: broken relative link: {target}")


def check_yaml() -> None:
    try:
        import yaml
    except ImportError:
        print("WARN: PyYAML not installed; YAML parse checks skipped")
        return
    for rel in YAML_FILES:
        try:
            yaml.safe_load((ROOT / rel).read_text(encoding="utf-8"))
        except Exception as exc:
            fail(f"invalid YAML in {rel}: {exc}")


def check_scaffold_contract() -> None:
    bootstrap = (ROOT / "BOOTSTRAP.md").read_text(encoding="utf-8")
    mappings = {
        "templates/client/AGENTS.md": "AGENTS.md",
        "templates/client/README.md": "README.md",
        "templates/client/.gitignore": ".gitignore",
        "templates/client/.gitattributes": ".gitattributes",
        "templates/client/manifest.yml": ".power-bi-vibes/manifest.yml",
        "templates/client/learning.yml": ".power-bi-vibes/learning.yml",
        "templates/client/report-spec.md": "_brief/report-spec.md",
        "templates/client/decisions.md": "_brief/decisions.md",
        "templates/client/data-contract.yml": "config/data-contract.yml",
        "templates/client/acceptance.md": "qa/acceptance.md",
    }
    for source, destination in mappings.items():
        if source not in bootstrap or destination not in bootstrap:
            fail(f"BOOTSTRAP missing scaffold mapping {source} -> {destination}")


def command_output(args: list[str]) -> str | None:
    try:
        result = subprocess.run(args, cwd=ROOT, check=True, text=True, capture_output=True)
        return result.stdout
    except FileNotFoundError:
        return None
    except subprocess.CalledProcessError as exc:
        fail(f"command failed: {' '.join(args)}: {exc.stderr.strip()}")
        return None


def check_pdf() -> None:
    pdf = ROOT / "docs/Power-BI-Vibes-Guide.pdf"
    data = pdf.read_bytes()
    if not data.startswith(b"%PDF-"):
        fail("client guide does not begin with a PDF header")
    if b"%%EOF" not in data[-2048:]:
        fail("client guide has no EOF marker near the end")

    info = command_output(["pdfinfo", str(pdf)])
    if info is None:
        print("WARN: pdfinfo unavailable; deep PDF checks skipped")
        return
    match = re.search(r"^Pages:\s+(\d+)", info, flags=re.MULTILINE)
    if not match:
        fail("pdfinfo did not report a page count")
        return
    pages = int(match.group(1))
    if pages < 1:
        fail("client guide has zero pages")
        return

    if not shutil_which("pdftotext"):
        print("WARN: pdftotext unavailable; blank-page text checks skipped")
        return
    for page in range(1, pages + 1):
        text = command_output(["pdftotext", "-f", str(page), "-l", str(page), str(pdf), "-"])
        if text is None:
            continue
        substantive = re.sub(r"\s+", "", text)
        if len(substantive) < 100:
            fail(f"client guide page {page} has too little extractable content ({len(substantive)} non-space chars)")


def shutil_which(name: str) -> str | None:
    import shutil
    return shutil.which(name)


def main() -> int:
    check_files()
    check_versions()
    check_markdown_links()
    check_yaml()
    check_scaffold_contract()
    check_pdf()
    if failures:
        print(f"Integrity audit failed with {failures} issue(s).")
        return 1
    print("Integrity audit passed.")
    return 0


failures = 0
if __name__ == "__main__":
    sys.exit(main())
