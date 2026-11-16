#!/bin/bash
# Tema Hijau Biru - dijalankan otomatis oleh bot setelah zip di-extract.
# Aman dijalankan ulang (idempotent). Backup config: tailwind.config.js.bak-hijau-biru
cd "${PTERO_DIR:-/var/www/pterodactyl}" || exit 1
CFG=tailwind.config.js

# 1) Warna utama (hijau) + palet gelap kebiruan lewat tailwind (butuh yarn build)
if [ -f "$CFG" ] && ! grep -q "THEME:hijau-biru" "$CFG"; then
  cp "$CFG" "$CFG.bak-hijau-biru"
  cat >> "$CFG" <<'EOF'

// THEME:hijau-biru
try {
  const _c = require('tailwindcss/colors');
  const _g = {
    50: '#f0fdfa', 100: '#dcf5f2', 200: '#bfe8e6', 300: '#9dd2d6', 400: '#6cb0bd',
    500: '#468a9b', 600: '#2c6a82', 700: '#1c4d63', 800: '#0f3347', 900: '#08202e',
  };
  const _x = module.exports.theme.extend.colors;
  _x.primary = _c.emerald;
  _x.gray = _g;
  _x.neutral = _g;
} catch (e) { console.warn('hijau-biru: ' + e.message); }
EOF
fi

# 2) Pasang CSS tambahan ke layout (sebelum </head>)
for f in resources/views/templates/*.blade.php resources/views/layouts/*.blade.php; do
  [ -f "$f" ] || continue
  grep -q '</head>' "$f" || continue
  grep -q 'themes/hijau-biru' "$f" && continue
  sed -i 's#</head>#    <link rel="stylesheet" href="/themes/hijau-biru/theme.css">\n</head>#' "$f"
done
echo "Tema hijau-biru terpasang"
