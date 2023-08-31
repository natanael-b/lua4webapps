# PWA

Generates the metatags required for WebApps

| Property      | What it does?                                                    |
|---------------|------------------------------------------------------------------|
| `manifest`    |  Specify the path of `manifest.json`¹                            |
| `statusbar`   |  Define the color of statusbar on Apple devices²                 |
| `theme_color` |  Defines the color of headerbar on Linux OSes that support this² |

> ¹ Defaults to "manifest.json" <br>
> ² Valid values are "black", "black-translucent" or "default" <br>
> ³ Uses the hexadecimal format

Example:

```lua
head {
  manifest = "app.json",
  statusbar = "black",
  theme_color = "#27ae60"
}
```

Will render:

```html
<head>
  <meta charset="utf8"/>
  <meta name="generator" content="lua-wpp"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <meta name="mobile-web-app-capable" content="yes"/>
  <meta name="apple-mobile-web-app-capable" content="yes"/>
  <meta name="theme-color" content="#27ae60"/>
  <meta name="apple-mobile-web-app-status-bar-style" content="black"/>
  <link name="manifest" href="app.json"/>
</head>
```


### The `icon` helper

Generate the icon metatags by passing the size and file path:

Example:

```lua
head {
    icons {
      [48] = "48px_icon.png",
      [64] = "64px_icon.png",
      [96] = "96px_icon.png",
    }
},
```


Will render:

```html
<head>
  <meta charset="utf8"/>
  <link href="48px_icon.png" sizes="48x48" rel="icon" type="image/png"/>
  <link href="48px_icon.png" sizes="48x48" rel="apple-touch-icon" type="image/png"/>
  <link href="96px_icon.png" sizes="96x96" rel="icon" type="image/png"/>
  <link href="96px_icon.png" sizes="96x96" rel="apple-touch-icon" type="image/png"/>
  <link href="64px_icon.png" sizes="64x64" rel="icon" type="image/png"/>
  <link href="64px_icon.png" sizes="64x64" rel="apple-touch-icon" type="image/png"/>
  <meta content="lua-wpp" name="generator"/>
  <meta content="width=device-width,initial-scale=1.0" name="viewport"/>
  <meta name="mobile-web-app-capable" content="yes"/><meta name="apple-mobile-web-app-capable" content="yes"/>
</head
```
