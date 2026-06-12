// Mahfadha — vector-drawn UI icons for the on-device TFT screen.
//
// Pure geometry (lines/rects/circles) drawn with TFT_eSPI primitives, so they
// render identically on any panel and need no emoji or special glyph fonts.
// Every icon fits inside an s×s box anchored at (x, y).

#pragma once
#include <TFT_eSPI.h>

// Padlock — lock / locked screen / boot
inline void iconLock(TFT_eSPI& tft, int x, int y, int s, uint16_t c) {
    int bw = s * 0.72, bh = s * 0.5;
    int bx = x + (s - bw) / 2, by = y + s - bh;
    tft.drawRoundRect(bx, by, bw, bh, 2, c);
    // shackle
    int r = s * 0.26;
    int cx = x + s / 2;
    tft.drawCircle(cx, by - r / 2, r, c);
    tft.fillRect(cx - r, by - r / 2, r * 2 + 1, r, TFT_BLACK); // trim lower half of ring
    tft.drawFastVLine(cx - r, by - r / 2, r / 2, c);
    tft.drawFastVLine(cx + r, by - r / 2, r / 2, c);
    // keyhole
    tft.fillCircle(bx + bw / 2, by + bh * 0.42, 2, c);
    tft.drawFastVLine(bx + bw / 2, by + bh * 0.42, bh * 0.35, c);
}

// Fingerprint — concentric arcs
inline void iconFinger(TFT_eSPI& tft, int x, int y, int s, uint16_t c) {
    int cx = x + s / 2, cy = y + s / 2;
    for (int i = 0; i < 4; i++) {
        int r = s * 0.12 + i * (s * 0.12);
        // draw upper 270 degrees of each ring for a fingerprint look
        tft.drawCircle(cx, cy, r, c);
        tft.fillRect(cx - r - 1, cy + r * 0.55, r * 2 + 2, r, TFT_BLACK);
    }
    tft.drawFastVLine(cx, cy - 1, s * 0.42, c);
}

// Key — passwords vault
inline void iconKey(TFT_eSPI& tft, int x, int y, int s, uint16_t c) {
    int r = s * 0.22;
    int cx = x + r + 1, cy = y + s - r - 1;
    tft.drawCircle(cx, cy, r, c);
    tft.drawCircle(cx, cy, r - 2, c);
    // shaft
    int ex = x + s - 1, ey = y + 1;
    tft.drawLine(cx + r * 0.7, cy - r * 0.7, ex, ey, c);
    // teeth
    tft.drawLine(ex, ey, ex - s * 0.18, ey + s * 0.18, c);
    tft.drawLine(ex - s * 0.22, ey + s * 0.22, ex - s * 0.40, ey + s * 0.04, c);
}

// Seed vault — 3x4 grid of dots (mnemonic words)
inline void iconSeed(TFT_eSPI& tft, int x, int y, int s, uint16_t c) {
    int cols = 3, rows = 4;
    int gx = s / (cols + 1), gy = s / (rows + 1);
    for (int r = 0; r < rows; r++)
        for (int col = 0; col < cols; col++)
            tft.fillCircle(x + gx * (col + 1), y + gy * (r + 1), 1, c);
}

// Shield — FIDO2 / security key
inline void iconShield(TFT_eSPI& tft, int x, int y, int s, uint16_t c) {
    int cx = x + s / 2;
    tft.drawLine(cx, y, x + s - 1, y + s * 0.22, c);
    tft.drawLine(x + s - 1, y + s * 0.22, x + s - 1, y + s * 0.55, c);
    tft.drawLine(x + s - 1, y + s * 0.55, cx, y + s - 1, c);
    tft.drawLine(cx, y + s - 1, x, y + s * 0.55, c);
    tft.drawLine(x, y + s * 0.55, x, y + s * 0.22, c);
    tft.drawLine(x, y + s * 0.22, cx, y, c);
    // check mark inside
    tft.drawLine(x + s * 0.30, y + s * 0.45, x + s * 0.45, y + s * 0.60, c);
    tft.drawLine(x + s * 0.45, y + s * 0.60, x + s * 0.70, y + s * 0.30, c);
}

// Gear — settings
inline void iconGear(TFT_eSPI& tft, int x, int y, int s, uint16_t c) {
    int cx = x + s / 2, cy = y + s / 2;
    int r = s * 0.30;
    tft.drawCircle(cx, cy, r, c);
    tft.drawCircle(cx, cy, r - 2 > 0 ? r - 2 : 1, c);
    // 8 teeth
    for (int a = 0; a < 360; a += 45) {
        float rad = a * 3.14159265 / 180.0;
        int x1 = cx + cos(rad) * r, y1 = cy + sin(rad) * r;
        int x2 = cx + cos(rad) * (r + s * 0.18), y2 = cy + sin(rad) * (r + s * 0.18);
        tft.drawLine(x1, y1, x2, y2, c);
    }
}

// Plug — connection hub (USB/BT)
inline void iconPlug(TFT_eSPI& tft, int x, int y, int s, uint16_t c) {
    int cx = x + s / 2;
    tft.drawFastVLine(cx - s * 0.18, y, s * 0.28, c);
    tft.drawFastVLine(cx + s * 0.18, y, s * 0.28, c);
    tft.drawRoundRect(x + s * 0.22, y + s * 0.28, s * 0.56, s * 0.30, 2, c);
    tft.drawFastVLine(cx, y + s * 0.58, s * 0.42, c);
}
