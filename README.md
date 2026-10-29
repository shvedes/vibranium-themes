# vibranium-themes

Monorepo containing all Vibranium themes maintained under the `shvedes` GitHub account.

Each theme lives in its own top-level folder and can be installed with the bundled `install.sh`.

## Install

One-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/shvedes/vibranium-themes/main/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/shvedes/vibranium-themes.git
cd vibranium-themes
./install.sh
```

By default themes are installed into `~/.config/vibranium/themes`. Override the destination with the `VIBRANIUM_THEMES_DIR` environment variable or pass it as the first argument:

```bash
VIBRANIUM_THEMES_DIR=/path/to/themes ./install.sh
```

## Themes

See [THEMES.md](./THEMES.md) for the full list with previews.
