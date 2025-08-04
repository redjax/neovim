# Shared Plugins <!-- omit in toc -->

A global 'store' of plugin configurations that can be imported into different profiles. A profile can either import all plugins, or selectively import from `nvim-shared.plugins.<pluginManager>.store` or `.bundles`.

## Table of Contents <!-- omit in toc -->

- [Plugin Managers](#plugin-managers)
  - [Lazy](#lazy)

## Plugin Managers

I have used different plugin managers over time, but have settled on [Lazy](https://github.com/folke/lazy.nvim) for a while. If/when I change to other plugin managers, I will create other plugin manager directories.

### Lazy

Plugins in the [`lazy/` path](./lazy/) are managed by the [Lazy plugin manager](https://github.com/folke/lazy.nvim).

Plugins are separated into 1 of 3 directories:

| Directory | Purpose |
| --------- | ------- |
| [`lazy/bundles/`](./lazy/bundles/) | Bundles are a collection of Lazy import statements that make it convenient to import a collection of plugins into a configuration. Import/requre `nvim-shared.plugins.bundles.bundle_name` to use them. |
| [`lazy/disabled/`](./lazy/disabled/) | Plugin configs I've disabled for one reason or another, but don't want to get rid of yet. |
| [`lazy/store/`](./lazy/store/) | A big ol' dumping ground for all of my plugin configs. This directory can be auto-imported by importing all `.lua` files (not recursively...), or selectively like `nvim-shared.plugins.lazy.store.plugin_name`. |
