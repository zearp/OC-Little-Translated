# Creating macOS `.icns` Files from a Single PNG

## Introduction

macOS uses the `.icns` format for storing icon resources. These files are commonly used for applications, documents, and folders. In this case, `.icns` files are used to create custom folder icons in Finder.

A high-resolution PNG can be converted into a complete `.icns` file using only built-in macOS tools.

This guide covers three workflows:

1. Using the **Make ICNS App** (drag-and-drop)
2. Using the **Create ICNS Finder Quick Action**
3. Manual creation via Terminal

## Requirements

* macOS
* A square PNG image, recommended size: **1024×1024 px**

The PNG should ideally contain transparency if it is intended as an icon.

---

## Method 1: Make ICNS App (Drag & Drop)

For a more convenient workflow, use the included **Make ICNS App**.

The application allows you to:

1. Drag a PNG file onto the app
2. Automatically generate all required icon sizes
3. Create the `.icns` file next to the original PNG

Example:

```
Maschine.png
```

becomes:

```
Maschine.icns
```

No Terminal commands are required.

**Download:**

[**Make ICNSS App**](/Content/T_Themes/ICNS/Make_ICNSS_App.zip)

---

## Method 2: Finder Quick Action

A Finder Quick Action integrates the conversion directly into Finder.

After installation:

1. Select one or more PNG files in Finder
2. Right-click
3. Choose:

```
Quick Actions → Create ICNS
```

The Quick Action will:

* generate the required `.iconset`
* create the `.icns` file
* remove temporary files

Example:

```
Kontakt.png
```

becomes:

```
Kontakt.icns
```

**Download:**

[**Create ICNS Quick Action**](/Content/T_Themes/ICNS/Create_ICNS_Quick_Action.zip)

### Installing the Finder Quick Action

The Finder Quick Action is stored as:

```
~/Library/Services/Create ICNS.workflow
```

It can be copied to another Mac/user by placing it into:

```
~/Library/Services/
```

For system-wide installation:

```
/Library/Services/
```

After copying, restart Finder:

```bash
killall Finder
```

---

# Method 3: Create an ICNS File via Terminal

macOS requires an intermediate `.iconset` directory containing multiple icon sizes.

## Generate the icon set

Open Terminal and navigate to the location of the PNG you want to convert.

Replace `source.png` with your PNG filename:

```bash
mkdir -p icon.iconset && \
for s in 16 32 128 256 512; do \
    sips -z $s $s source.png --out icon.iconset/icon_${s}x${s}.png >/dev/null; \
    sips -z $((s*2)) $((s*2)) source.png --out icon.iconset/icon_${s}x${s}@2x.png >/dev/null; \
done
```

This creates the different icon sizes required by Finder so it can display the icon correctly depending on the selected folder view:

```
icon.iconset/
├── icon_16x16.png
├── icon_16x16@2x.png
├── icon_32x32.png
├── icon_32x32@2x.png
├── icon_128x128.png
├── icon_128x128@2x.png
├── icon_256x256.png
├── icon_256x256@2x.png
├── icon_512x512.png
└── icon_512x512@2x.png
```

## Convert the iconset to `.icns`

Run:

```bash
iconutil -c icns icon.iconset
```

The result:

```
icon.icns
```

---

## Troubleshooting

### Common Error: "Iconset not found"

If you see:

```
icon.iconset: Iconset not found.
```

you are most likely inside the `icon.iconset` directory already.

Wrong:

```
icon.iconset/
    icon_16x16.png
    icon_32x32.png
```

Running:

```bash
iconutil -c icns icon.iconset
```

here makes `iconutil` look for:

```
icon.iconset/icon.iconset
```

which does not exist.

Move one directory up:

```bash
cd ..
iconutil -c icns icon.iconset
```

---

## Tools Used

| Tool | Purpose |
|---|---|
| `sips` | Generates required PNG icon sizes |
| `iconutil` | Packages the iconset into `.icns` |
| Automator | Creates Finder Quick Actions |

All required tools are included with macOS.

---

## Additional Resources

- [Creating ICNS files for macOS apps: A developer's guide](https://www.mycyberuniverse.com/creating-icns-files-macos-apps-developer-guide) by Arthur Gareginyan
- [Custom Mac Icons](https://github.com/eth-p/mac-icons) – Custom MacOS folder icons designed to match the native look and feel.