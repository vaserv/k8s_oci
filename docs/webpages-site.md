# Webpages Site

`https://fsck.me.uk`, `https://www.fsck.me.uk`, `https://rghf.nl`, and `https://www.rghf.nl`
are the hosted wrapper for the project documentation and the public home pages.

## What it contains

- A landing page for the hosted docs site
- The deployment and platform notes
- The reusable OCI HTML template
- A short blog that tracks the rollout

## Why it exists

The repository already has the source docs. The site turns those files into something the
cluster can serve directly, which makes the operational state visible from the same server that
runs the workloads.

## Live routes

`https://fsck.me.uk`
`https://www.fsck.me.uk`
`https://rghf.nl`
`https://www.rghf.nl`

## Layout

- `index.html` is the landing page
- `docs/` contains the hosted docs
- `blog/` contains the build log
- `assets/site.css` holds the shared styling

## Deployment

The content is packaged into a tiny OCI image and mounted into an nginx container using the
Kubernetes 1.36 `image` volume feature.
