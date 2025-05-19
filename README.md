# Jascha's Website

This repository contains the source files for the personal website hosted at [jascha.me](https://jascha.me).

## Site Structure

The website is built using [MkDocs](https://www.mkdocs.org/) with the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme.

- `mkdocs.yml` - Main configuration file
- `docs/` - Source markdown files for the website content
  - `index.md` - Homepage content
  - `about/index.md` - About page content
  - `img/` - Images used in the site

## Setup

1. Install MkDocs and the Material theme:

```bash
pip install mkdocs mkdocs-material
```

## Development

1. Run the development server:

```bash
mkdocs serve
```

2. View the site at [http://localhost:8000](http://localhost:8000)

## Adding Content

### Adding a New Page

1. Create a new markdown file in the `docs/` directory or a subdirectory
2. Add the page to the navigation in `mkdocs.yml`

Example addition to `mkdocs.yml`:

```yaml
nav:
  - Home: index.md
  - About: about/index.md
  - New Page: new-page.md
```

## Building and Deployment

### Building the Site

To build the static site:

```bash
mkdocs build
```

This will generate a `site/` directory with the built HTML files.

### Deployment

#### GitHub Pages Method

For deploying to GitHub Pages:

```bash
mkdocs gh-deploy
```

This builds the site and pushes it to the `gh-pages` branch of your repository.

#### Manual Deployment

1. Build the site: `mkdocs build`
2. Copy the contents of the `site/` directory to your web server or hosting service

## Maintenance Tips

1. Keep your MkDocs and theme up-to-date:
   ```bash
   pip install --upgrade mkdocs mkdocs-material
   ```

2. To add custom CSS or JavaScript, create directories:
   ```bash
   mkdir -p docs/assets/stylesheets docs/assets/javascripts
   ```
   Then add the customization files there and reference them in `mkdocs.yml`.

## Resources

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material for MkDocs Documentation](https://squidfunk.github.io/mkdocs-material/)
