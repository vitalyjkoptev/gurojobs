#!/usr/bin/env python3
"""Generate GJ app icon + 4 neon vertical icons for GURO JOBS splash."""
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os

ASSETS = os.path.dirname(__file__) + '/assets/images'
os.makedirs(ASSETS, exist_ok=True)

# ===== 1. APP ICON: "GJ" on dark blue =====
def create_app_icon():
    size = 1024
    img = Image.new('RGBA', (size, size), (1, 74, 133, 255))  # #014A85
    draw = ImageDraw.Draw(img)

    # Try system fonts for bold text
    font = None
    for f in [
        '/System/Library/Fonts/Helvetica.ttc',
        '/System/Library/Fonts/SFNSDisplay.ttf',
        '/Library/Fonts/Arial Bold.ttf',
        '/System/Library/Fonts/HelveticaNeue.ttc',
    ]:
        try:
            font = ImageFont.truetype(f, int(size * 0.48))
            break
        except:
            continue
    if not font:
        font = ImageFont.load_default()

    text = 'GJ'
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    x = (size - tw) // 2 - bbox[0]
    y = (size - th) // 2 - bbox[1]

    # White text
    draw.text((x, y), text, fill=(255, 255, 255, 255), font=font)

    img.save(f'{ASSETS}/icon.png', 'PNG')
    print(f'Created icon.png ({size}x{size})')


# ===== 2. NEON ICONS for splash =====
def create_neon_icon(name, draw_func):
    """Create a single neon icon with glow effect."""
    size = 256
    # Transparent background
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    neon = (79, 195, 247)  # #4FC3F7 cyan

    # Draw the icon shape
    draw_func(draw, size, neon)

    # Add glow: blur a copy and composite
    glow = img.copy().filter(ImageFilter.GaussianBlur(radius=8))
    glow2 = img.copy().filter(ImageFilter.GaussianBlur(radius=16))

    result = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    result = Image.alpha_composite(result, glow2)
    result = Image.alpha_composite(result, glow)
    result = Image.alpha_composite(result, img)

    result.save(f'{ASSETS}/{name}.png', 'PNG')
    print(f'Created {name}.png ({size}x{size})')


def draw_igaming(draw, s, c):
    """Casino/iGaming icon: diamond + chips style."""
    cx, cy = s // 2, s // 2
    # Diamond shape
    pts = [(cx, cy - 60), (cx + 50, cy), (cx, cy + 60), (cx - 50, cy)]
    draw.polygon(pts, outline=c, width=3)
    # Crown on top
    draw.line([(cx - 30, cy - 70), (cx - 20, cy - 85), (cx, cy - 75), (cx + 20, cy - 85), (cx + 30, cy - 70)], fill=c, width=3)
    # Chip circle
    draw.ellipse([(cx - 25, cy - 25), (cx + 25, cy + 25)], outline=c, width=2)
    # Arrow up
    draw.line([(cx + 40, cy + 10), (cx + 40, cy - 40)], fill=c, width=3)
    draw.polygon([(cx + 30, cy - 30), (cx + 40, cy - 50), (cx + 50, cy - 30)], fill=c)
    # Heart
    draw.ellipse([(cx - 55, cy - 20), (cx - 40, cy - 5)], fill=c)
    draw.ellipse([(cx - 45, cy - 20), (cx - 30, cy - 5)], fill=c)
    draw.polygon([(cx - 55, cy - 10), (cx - 42, cy + 10), (cx - 30, cy - 10)], fill=c)


def draw_crypto(draw, s, c):
    """Bitcoin/Crypto icon: hexagonal network + B."""
    cx, cy = s // 2, s // 2
    import math
    # Hexagon
    r = 55
    hex_pts = [(cx + int(r * math.cos(math.radians(60 * i + 30))),
                cy + int(r * math.sin(math.radians(60 * i + 30)))) for i in range(6)]
    draw.polygon(hex_pts, outline=c, width=3)
    # Inner hexagon
    r2 = 35
    hex2 = [(cx + int(r2 * math.cos(math.radians(60 * i + 30))),
             cy + int(r2 * math.sin(math.radians(60 * i + 30)))) for i in range(6)]
    draw.polygon(hex2, outline=c, width=2)
    # Lines connecting hexagons
    for i in range(6):
        draw.line([hex2[i], hex_pts[i]], fill=c, width=2)
    # B in center
    font = None
    for f in ['/System/Library/Fonts/Helvetica.ttc', '/Library/Fonts/Arial Bold.ttf']:
        try:
            font = ImageFont.truetype(f, 36)
            break
        except:
            continue
    if font:
        bbox = draw.textbbox((0, 0), 'B', font=font)
        tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
        draw.text((cx - tw // 2 - bbox[0], cy - th // 2 - bbox[1]), 'B', fill=c, font=font)
    # Outer dots
    for i in range(6):
        x, y = hex_pts[i]
        draw.ellipse([(x - 5, y - 5), (x + 5, y + 5)], fill=c)


def draw_fintech(draw, s, c):
    """Fintech icon: chart + dollar."""
    cx, cy = s // 2, s // 2
    # Bar chart
    bars = [(cx - 50, cy + 30, cx - 30, cy + 60),
            (cx - 20, cy, cx, cy + 60),
            (cx + 10, cy - 20, cx + 30, cy + 60),
            (cx + 40, cy - 40, cx + 60, cy + 60)]
    for b in bars:
        draw.rectangle(b, outline=c, width=2)
    # Trend line
    draw.line([(cx - 40, cy + 10), (cx - 10, cy - 20), (cx + 20, cy - 40), (cx + 50, cy - 60)], fill=c, width=3)
    # Dollar circle top
    draw.ellipse([(cx - 5, cy - 75), (cx + 35, cy - 40)], outline=c, width=2)
    font = None
    for f in ['/System/Library/Fonts/Helvetica.ttc']:
        try:
            font = ImageFont.truetype(f, 22)
            break
        except:
            continue
    if font:
        draw.text((cx + 7, cy - 72), '$', fill=c, font=font)
    # People silhouettes at bottom
    for px in [cx - 35, cx + 5]:
        draw.ellipse([(px, cy + 62), (px + 10, cy + 72)], fill=c)
        draw.arc([(px - 5, cy + 70), (px + 15, cy + 90)], 0, 180, fill=c, width=2)


def draw_nutra(draw, s, c):
    """Nutra icon: leaf + health cross."""
    cx, cy = s // 2, s // 2
    # Main leaf shape (bezier approximation with polygon)
    leaf = [
        (cx - 10, cy + 50),
        (cx - 45, cy + 20),
        (cx - 55, cy - 10),
        (cx - 45, cy - 40),
        (cx - 20, cy - 60),
        (cx, cy - 65),
        (cx + 20, cy - 55),
        (cx + 35, cy - 30),
        (cx + 40, cy),
        (cx + 30, cy + 25),
        (cx + 10, cy + 50),
    ]
    draw.polygon(leaf, outline=c, width=3)
    # Leaf vein
    draw.line([(cx - 5, cy + 45), (cx - 10, cy - 10), (cx - 5, cy - 55)], fill=c, width=2)
    draw.line([(cx - 10, cy + 10), (cx - 30, cy - 10)], fill=c, width=2)
    draw.line([(cx - 8, cy - 5), (cx + 15, cy - 20)], fill=c, width=2)
    draw.line([(cx - 10, cy - 25), (cx - 30, cy - 35)], fill=c, width=2)
    # Health cross (top-right)
    cross_x, cross_y = cx + 45, cy - 45
    draw.rectangle([(cross_x - 3, cross_y - 12), (cross_x + 3, cross_y + 12)], fill=c)
    draw.rectangle([(cross_x - 12, cross_y - 3), (cross_x + 12, cross_y + 3)], fill=c)


if __name__ == '__main__':
    create_app_icon()
    create_neon_icon('icon_igaming', draw_igaming)
    create_neon_icon('icon_crypto', draw_crypto)
    create_neon_icon('icon_fintech', draw_fintech)
    create_neon_icon('icon_nutra', draw_nutra)
    print('\nAll icons created in', ASSETS)
