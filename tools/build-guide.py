#!/usr/bin/env python3
"""Build the Power BI Vibes client PDF from docs/getting-started.md."""
from __future__ import annotations

import html
import re
import shutil
import subprocess
import textwrap
from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import ListFlowable, ListItem, Paragraph, Preformatted, SimpleDocTemplate, Spacer, Table, TableStyle

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "docs" / "getting-started.md"
OUT = ROOT / "docs" / "Power-BI-Vibes-Guide.pdf"
RAW = ROOT / "docs" / ".Power-BI-Vibes-Guide.raw.pdf"
VERSION = (ROOT / "VERSION").read_text(encoding="utf-8").strip()

ACCENT = colors.HexColor("#234075")
TEXT = colors.HexColor("#1F2937")
MUTED = colors.HexColor("#5B6470")
CODE_BG = colors.HexColor("#F1F4F8")
RULE = colors.HexColor("#D9DEE7")


def inline_markup(text: str) -> str:
    text = html.escape(text, quote=False)
    text = re.sub(r"`([^`]+)`", r'<font name="Courier">\1</font>', text)
    text = re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", text)
    return text


def footer(canvas, doc):
    canvas.saveState()
    width, _ = letter
    canvas.setStrokeColor(RULE)
    canvas.line(doc.leftMargin, 0.40 * inch, width - doc.rightMargin, 0.40 * inch)
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(MUTED)
    canvas.drawString(doc.leftMargin, 0.22 * inch, f"Power BI Vibes | v{VERSION}")
    canvas.drawRightString(width - doc.rightMargin, 0.22 * inch, str(doc.page))
    canvas.restoreState()


def parse_markdown(md: str):
    styles = getSampleStyleSheet()
    title = ParagraphStyle("TitlePBV", parent=styles["Title"], fontName="Helvetica-Bold", fontSize=27, leading=30, alignment=TA_CENTER, textColor=colors.black, spaceAfter=7)
    subtitle = ParagraphStyle("VersionPBV", parent=styles["Normal"], fontName="Helvetica", fontSize=10.5, leading=13, alignment=TA_CENTER, textColor=MUTED, spaceAfter=14)
    h2 = ParagraphStyle("H2PBV", parent=styles["Heading2"], fontName="Helvetica-Bold", fontSize=16, leading=19, textColor=ACCENT, spaceBefore=11, spaceAfter=6, keepWithNext=True)
    body = ParagraphStyle("BodyPBV", parent=styles["BodyText"], fontName="Helvetica", fontSize=9.8, leading=13.4, textColor=TEXT, spaceAfter=6)
    code = ParagraphStyle("CodePBV", parent=styles["Code"], fontName="Courier", fontSize=8.2, leading=10.3, leftIndent=8, rightIndent=8, borderPadding=7, backColor=CODE_BG, textColor=TEXT, spaceBefore=3, spaceAfter=8)
    list_body = ParagraphStyle("ListPBV", parent=body, leftIndent=0, firstLineIndent=0, spaceAfter=1)

    lines = md.splitlines()
    story = []
    i = 0
    seen_title = False
    while i < len(lines):
        line = lines[i].rstrip()
        if not line.strip():
            i += 1
            continue
        if line.startswith("# "):
            story.append(Spacer(1, 0.10 * inch))
            story.append(Paragraph(inline_markup(line[2:].strip()), title))
            story.append(Paragraph(f"Client Guide - v{VERSION}", subtitle))
            seen_title = True
            i += 1
            continue
        if line.startswith("## "):
            story.append(Paragraph(inline_markup(line[3:].strip()), h2))
            i += 1
            continue
        if line.startswith("```"):
            block = []
            i += 1
            while i < len(lines) and not lines[i].startswith("```"):
                block.append(lines[i])
                i += 1
            if i < len(lines):
                i += 1
            wrapped = []
            for code_line in block:
                if not code_line:
                    wrapped.append("")
                    continue
                wrapped.extend(textwrap.wrap(code_line, width=92, break_long_words=False, break_on_hyphens=False) or [""])
            story.append(Preformatted("\n".join(wrapped), code))
            continue
        if line.startswith("|") and i + 1 < len(lines) and re.match(r"^\|(?:\s*:?-+:?\s*\|)+$", lines[i + 1].strip()):
            header = [c.strip() for c in line.strip().strip("|").split("|")]
            i += 2
            rows = [header]
            while i < len(lines) and lines[i].strip().startswith("|"):
                rows.append([c.strip() for c in lines[i].strip().strip("|").split("|")])
                i += 1
            data = [[Paragraph(inline_markup(c), body) for c in row] for row in rows]
            table = Table(data, repeatRows=1, hAlign="LEFT")
            table.setStyle(TableStyle([("BACKGROUND", (0, 0), (-1, 0), CODE_BG), ("TEXTCOLOR", (0, 0), (-1, -1), TEXT), ("GRID", (0, 0), (-1, -1), 0.35, RULE), ("VALIGN", (0, 0), (-1, -1), "TOP"), ("LEFTPADDING", (0, 0), (-1, -1), 5), ("RIGHTPADDING", (0, 0), (-1, -1), 5)]))
            story.append(table)
            story.append(Spacer(1, 0.08 * inch))
            continue
        if re.match(r"^\d+\.\s+", line):
            items = []
            while i < len(lines) and re.match(r"^\d+\.\s+", lines[i]):
                items.append(ListItem(Paragraph(inline_markup(re.sub(r"^\d+\.\s+", "", lines[i]).strip()), list_body)))
                i += 1
            story.append(ListFlowable(items, bulletType="1", leftIndent=22, bulletFontName="Helvetica", bulletFontSize=9, spaceAfter=6))
            continue
        if line.startswith("- "):
            items = []
            while i < len(lines) and lines[i].startswith("- "):
                items.append(ListItem(Paragraph(inline_markup(lines[i][2:].strip()), list_body)))
                i += 1
            story.append(ListFlowable(items, bulletType="bullet", leftIndent=22, bulletFontName="Helvetica", bulletFontSize=8.7, spaceAfter=6))
            continue
        para = [line.strip()]
        i += 1
        while i < len(lines):
            nxt = lines[i].rstrip()
            if not nxt.strip() or nxt.startswith("#") or nxt.startswith("```") or nxt.startswith("- ") or nxt.startswith("|") or re.match(r"^\d+\.\s+", nxt):
                break
            para.append(nxt.strip())
            i += 1
        story.append(Paragraph(inline_markup(" ".join(para)), body))

    if not seen_title:
        raise RuntimeError("Guide source is missing its H1 title")
    return story


def find_ghostscript() -> str | None:
    for name in ("gs", "gswin64c", "gswin32c"):
        path = shutil.which(name)
        if path:
            return path
    return None


def build():
    md = SOURCE.read_text(encoding="utf-8")
    doc = SimpleDocTemplate(str(RAW), pagesize=letter, leftMargin=0.68 * inch, rightMargin=0.68 * inch, topMargin=0.56 * inch, bottomMargin=0.53 * inch, title="Power BI Vibes - Client Guide", author="Earlhealy", pageCompression=0)
    doc.build(parse_markdown(md), onFirstPage=footer, onLaterPages=footer)
    gs = find_ghostscript()
    if gs:
        subprocess.run([gs, "-q", "-dNOPAUSE", "-dBATCH", "-sDEVICE=pdfwrite", "-dCompatibilityLevel=1.4", "-dPDFSETTINGS=/prepress", f"-sOutputFile={OUT}", str(RAW)], check=True)
        RAW.unlink(missing_ok=True)
    else:
        RAW.replace(OUT)
    data = OUT.read_bytes()
    if not data.startswith(b"%PDF-") or b"%%EOF" not in data[-2048:]:
        raise RuntimeError("Generated output failed basic PDF integrity checks")
    print(f"Built {OUT} ({len(data)} bytes)")


if __name__ == "__main__":
    build()
