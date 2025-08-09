# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

figtree.nvim is a Neovim plugin that displays a figlet startup banner. The plugin renders ASCII art text using the `figlet` command and shows it as a startup screen when Neovim opens without files.

## Architecture

The plugin is structured with clear separation of concerns:

- `init.lua`: Main entry point with setup function and default configuration
- `types.lua`: Type definitions for config and state objects
- `render.lua`: Banner rendering logic with padding, version display, and buffer population
- `io.lua`: Figlet command execution with caching system (stores banners in `~/.cache/figtree.nvim/`)
- `callbacks.lua`: Event handling for startup, window management, cursor hiding/showing, and buffer cleanup
- `utils.lua`: Utility functions for string manipulation and error handling

## Key Components

### Configuration System
Uses `vim.tbl_deep_extend` to merge user options with defaults. Core config includes:
- `text`: Banner text content
- `font`: Figlet font name
- `show_version`: Version display settings
- `remaps`: Key bindings for the banner buffer

### Caching Mechanism
Caches figlet output by font in `~/.cache/figtree.nvim/banners/`. Cache invalidation occurs when text changes, tracked via `text.txt` file.

### Buffer Management
Creates special buffer (type=nofile, bufhidden=delete) with custom options and autocommands for:
- Window creation handling
- Cursor visibility management
- Resize responsiveness
- Buffer cleanup

## Dependencies

- `figlet` command must be available in PATH
- Uses standard Neovim Lua API and vim functions

## Development Notes

No build/test/lint commands are present - this is a pure Lua plugin. Testing would require Neovim runtime environment with the plugin loaded.