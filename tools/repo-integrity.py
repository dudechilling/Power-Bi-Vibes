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
    "CLAUDE.md",
    "CHANGELOG.md",
    "README.md",
    "THIRD_PARTY_NOTICES.md",
    "UPSTREAM.lock.yml",
    "VERSION",
    "workflows/bootstrap.md",
    "workflows/update.md",
    "policy/data.md",
    "policy/git.md",
    "policy/learning.md",
    "policy/power-bi.md",
    "policy/privacy.md",
    "policy/qa.md",
    "docs/getting-started.md",
    "docs/github-setup.md",
    "docs/windows-setup.md",
    "docs/Power-BI-Vibes-Guide.pdf",
    "maintainer/framework.md",
    "maintainer/release.md",
    "maintainer/evals/repository-modes.md",
    "tools/build-guide.py",
    "tools/repo-integrity.py",
    "tools/inspect-source.ps1",
    "tools/test-inspect-source.ps1",
    "tools/claude-artifact-guard.ps1",
    "prompts/BOOTSTRAP.txt",
    "prompts/RESUME.txt",
    "prompts/UPDATE.txt",
    "templates/client/.gitattributes",
    "templates/client/.gitignore",
    "templates/client/AGENTS.md",
    "templates/client/CLAUDE.md",
    "templates/client/README.md",
    "templates/client/.power-bi-vibes/manifest.yml",
    "templates/client/.power-bi-vibes/learning.yml",
    "templates/client/_brief/report-spec.md",
    "templates/client/_brief/decisions.md",
    "templates/client/config/data-contract.yml",
    "templates/client/qa/acceptance.md",
    "templates/client/scripts/check-local-setup.ps1",
]

MARKDOWN = [p for p in REQUIRED if p.endswith(".md")]
YAML_FILES = [
    "UPSTREAM.lock.yml",
    "templates/client/config/data-contract.yml",
    "templates/client/.power-bi-vibes/learning.yml",
    "templates/client/.power-bi-vibes/manifest.yml",
]

failures = 0


def fail(message: str) -> None:
    global failures
    print(f"ERROR: {message}")
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
    changelog = (ROOT / "CHANGELOG.md").read_text(encoding="utf-8")
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


def check_template_mirror() -> None:
    required_client = [
        "AGENTS.md", "CLAUDE.md", "README.md", ".gitignore", ".gitattributes",
        ".power-bi-vibes/manifest.yml", ".power-bi-vibes/learning.yml",
        "_brief/report-spec.md", "_brief/decisions.md", "config/data-contract.yml",
        "qa/acceptance.md", "scripts/check-local-setup.ps1",
    ]
    for rel in required_client:
        if not (ROOT / "templates" / "client" / rel).is_file():
            fail(f"client template does not mirror installed path: {rel}")

    bootstrap = (ROOT / "workflows/bootstrap.md").read_text(encoding="utf-8")
    if "template path equals installed path" not in bootstrap:
        fail("bootstrap does not state mirrored template contract")


def check_policy_routing() -> None:
    agents = (ROOT / "AGENTS.md").read_text(encoding="utf-8")
    for rel in [
        "policy/data.md", "policy/git.md", "policy/privacy.md", "policy/qa.md",
        "policy/learning.md", "policy/power-bi.md", "workflows/bootstrap.md",
    ]:
        if rel not in agents:
            fail(f"AGENTS.md does not route to {rel}")
    if (ROOT / "CLAUDE.md").read_text(encoding="utf-8").strip() != "@AGENTS.md":
        fail("root CLAUDE.md is not a thin @AGENTS.md wrapper")
    if (ROOT / "templates/client/CLAUDE.md").read_text(encoding="utf-8").strip() != "@AGENTS.md":
        fail("client CLAUDE.md is not a thin @AGENTS.md wrapper")


def check_local_qa_handoff_contract() -> None:
    required_phrases = {
        "AGENTS.md": ["Client-repository completion handoff", "Local QA handoff", "git pull --ff-only", "Start-Process"],
        "templates/client/AGENTS.md": ["Local QA handoff after changes", "git pull --ff-only", "Start-Process"],
        "policy/qa.md": ["Local QA handoff", "git pull --ff-only", "Start-Process"],
        "workflows/bootstrap.md": ["Local QA handoff", "copy/paste PowerShell block"],
        "docs/getting-started.md": ["Local QA handoff", "git pull --ff-only"],
    }
    for rel, phrases in required_phrases.items():
        text = (ROOT / rel).read_text(encoding="utf-8")
        for phrase in phrases:
            if phrase not in text:
                fail(f"{rel}: missing local QA handoff contract phrase: {phrase}")


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
    if not match or int(match.group(1)) < 1:
        fail("pdfinfo did not report a valid page count")


def check_no_superseded_paths() -> None:
    old_paths = [
        "BOOTSTRAP.md", "START-HERE.md",
        "framework/OPERATING-RULES.md", "framework/DATA.md", "framework/GIT.md",
        "framework/LEARNING.md", "framework/MICROSOFT-POWERBI.md",
        "framework/PRIVACY.md", "framework/QA.md", "framework/UPDATES.md",
        "docs/CREATE-PRIVATE-REPO.md", "docs/WINDOWS-SETUP.md",
        "docs/Power-BI-Vibes-Guide.md", "docs/REPOSITORY-MODE-EVALS.md",
        "docs/build_guide.py", "scripts/repo_integrity.py", "scripts/inspect-source.ps1",
        "scripts/check-local-setup.ps1", "templates/client/manifest.yml",
        "templates/client/learning.yml", "templates/client/report-spec.md",
        "templates/client/decisions.md", "templates/client/data-contract.yml",
        "templates/client/acceptance.md",
    ]
    for rel in old_paths:
        if (ROOT / rel).exists():
            fail(f"superseded path still exists: {rel}")


def main() -> int:
    check_files()
    check_versions()
    check_markdown_links()
    check_yaml()
    check_template_mirror()
    check_policy_routing()
    check_local_qa_handoff_contract()
    check_no_superseded_paths()
    check_pdf()
    if failures:
        print(f"Integrity audit failed with {failures} issue(s).")
        return 1
    print("Integrity audit passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
