# Metatags

Generates the metatags from properties of `head` tag:

| Property | Metatag |
|--|--|
| `description` |  `description` and `og:description` |
| `keywords` | `keywords` |
| `author` | `author` |
| `image` | `og:image` |
| `video` | `og:video` |
| `audio` | `og:audio` |
| `url` | `og:url` | 
| `title` | `title`¹ |


> ¹ This is will also generate the `title` tag

Example:

```lua
head {
  title = "The Rock (1996)",
  url = "https://www.imdb.com/title/tt0117500/",
  image ="https://ia.media-imdb.com/images/rock.jpg",
}
```

Will render:

```html
<head>
  <meta charset="utf8">
  <meta content="lua-wpp" name="generator">
  <meta content="width=device-width,initial-scale=1.0" name="viewport">
  <meta property="og:image" content="https://ia.media-imdb.com/images/rock.jpg">
  <meta property="og:url" content="https://www.imdb.com/title/tt0117500/">
  <meta property="og:title" content="The Rock (1996)">
  <title>The Rock (1996)</title>
</head>
```