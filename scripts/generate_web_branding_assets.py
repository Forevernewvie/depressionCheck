#!/usr/bin/env python3
"""Purpose: Generate web favicon/PWA/social assets from one master app icon."""
from __future__ import annotations

from pathlib import Path
from PIL import Image, ImageOps, ImageDraw

SOURCE = Path("assets/branding/app_icon/app_icon_master_1024.png")
WEB_DIR = Path("web")
ICONS_DIR = WEB_DIR / "icons"

THEME_HEX = "#2A6E61"
SURFACE_HEX = "#F3F8F6"


def _hex_to_rgb(value: str) -> tuple[int, int, int]:
    value = value.lstrip("#")
    return tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))


def _save_square_icon(source: Image.Image, size: int, output: Path) -> None:
    fitted = ImageOps.fit(source, (size, size), method=Image.Resampling.LANCZOS)
    fitted.save(output, format="PNG", optimize=True)


def _save_maskable_icon(source: Image.Image, size: int, output: Path) -> None:
    bg = Image.new("RGBA", (size, size), _hex_to_rgb(THEME_HEX) + (255,))
    safe_size = int(size * 0.74)
    icon = ImageOps.fit(source, (safe_size, safe_size), method=Image.Resampling.LANCZOS)
    offset = ((size - safe_size) // 2, (size - safe_size) // 2)
    bg.alpha_composite(icon, offset)
    bg.save(output, format="PNG", optimize=True)


def _save_favicon(source: Image.Image, output: Path) -> None:
    icon = ImageOps.fit(source, (48, 48), method=Image.Resampling.LANCZOS)
    icon.resize((16, 16), Image.Resampling.LANCZOS).save(output, format="PNG", optimize=True)


def _save_social_preview(source: Image.Image, output: Path) -> None:
    width, height = 1200, 630
    canvas = Image.new("RGBA", (width, height), _hex_to_rgb(SURFACE_HEX) + (255,))

    # Soft radial gradient accents.
    draw = ImageDraw.Draw(canvas)
    draw.ellipse((-140, -160, 420, 400), fill=(42, 110, 97, 36))
    draw.ellipse((760, 220, 1300, 760), fill=(42, 110, 97, 28))

    icon_size = 320
    icon = ImageOps.fit(source, (icon_size, icon_size), method=Image.Resampling.LANCZOS)
    canvas.alpha_composite(icon, (96, (height - icon_size) // 2))

    # Minimal typography blocks (kept image-only to avoid font dependency issues).
    draw.rounded_rectangle((460, 170, 1110, 270), radius=20, fill=(42, 110, 97, 220))
    draw.rounded_rectangle((460, 300, 1060, 356), radius=16, fill=(42, 110, 97, 54))
    draw.rounded_rectangle((460, 376, 980, 432), radius=16, fill=(42, 110, 97, 54))

    canvas.convert("RGB").save(output, format="PNG", optimize=True)


def main() -> None:
    if not SOURCE.exists():
        raise FileNotFoundError(f"Missing source icon: {SOURCE}")

    WEB_DIR.mkdir(parents=True, exist_ok=True)
    ICONS_DIR.mkdir(parents=True, exist_ok=True)

    source = Image.open(SOURCE).convert("RGBA")

    _save_favicon(source, WEB_DIR / "favicon.png")
    _save_square_icon(source, 192, ICONS_DIR / "Icon-192.png")
    _save_square_icon(source, 512, ICONS_DIR / "Icon-512.png")
    _save_maskable_icon(source, 192, ICONS_DIR / "Icon-maskable-192.png")
    _save_maskable_icon(source, 512, ICONS_DIR / "Icon-maskable-512.png")
    _save_social_preview(source, ICONS_DIR / "social-preview-1200x630.png")


if __name__ == "__main__":
    main()
