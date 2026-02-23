# Dynamic Wallpaper

MacOS supports dynamic wallpapers - single `.heic` files that switch between light and dark
variants automatically when the system theme changes.

## Creating a dynamic wallpaper

From this directory, run:

```bash
git clone https://github.com/mczachurski/wallpapper.git
cd wallpaper
swift build --configuration release

cat > wallpapper.json <<'EOF'
[
  {
    "fileName": "dark.jpg",
    "isPrimary": true,
    "isForDark": true
  },
  {
    "fileName": "light.jpg",
    "isForLight": true
  }
]
EOF

.build/release/wallpapper -i wallpapper.json -o wallpaper.heic
```
