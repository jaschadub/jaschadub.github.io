---
title: Getting Started with MkDocs
date: 2025-05-18
tags:
  - mkdocs
  - tutorial
---

# Getting Started with MkDocs

*Posted on May 18, 2025*

[MkDocs](https://www.mkdocs.org/) is a fantastic static site generator that's perfect for documentation sites, blogs, and personal websites. In this post, I'll share why I chose MkDocs for my personal site and how you can get started with it too.

## Why MkDocs?

There are plenty of static site generators out there, so why choose MkDocs?

1. **Markdown-based** - Write content in simple Markdown format
2. **Python-powered** - Easy to extend and customize
3. **Great themes** - Especially the Material theme
4. **Fast** - Quick build times and optimized output
5. **Simple configuration** - Just one YAML file

## Quick Start Guide

Getting started with MkDocs is straightforward:

```bash
# Install MkDocs and the Material theme
pip install mkdocs mkdocs-material

# Create a new project
mkdocs new my-website
cd my-website

# Start the development server
mkdocs serve
```

Then open `http://localhost:8000` in your browser, and you'll see your site!

## Basic Site Structure

A simple MkDocs site has this structure:

```
my-website/
├── docs/
│   └── index.md
└── mkdocs.yml
```

The `mkdocs.yml` file controls your site configuration:

```yaml
site_name: My Website
theme: material
nav:
  - Home: index.md
  - About: about.md
```

## Adding Content

Creating content is as simple as adding Markdown files to your `docs/` directory. For example, to add an about page:

1. Create `docs/about.md`
2. Add "About" to your navigation in `mkdocs.yml`
3. Write your content in Markdown

## Advanced Features

MkDocs with the Material theme offers many advanced features:

- Syntax highlighting for code
- Search functionality
- Dark mode support
- Icon integration
- Admonitions (note blocks, warnings, etc.)
- And much more!

## Example Admonition

Here's a simple example of an admonition:

!!! tip "Pro Tip"
    You can use `mkdocs gh-deploy` to automatically build and deploy your site to GitHub Pages.

## Conclusion

MkDocs is an excellent choice for creating documentation sites, personal websites, or blogs. It's simple to use yet powerful enough for complex sites.

In future posts, I'll dive deeper into customizing MkDocs and share some of my favorite plugins and extensions.
