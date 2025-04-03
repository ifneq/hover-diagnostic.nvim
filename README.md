# Diagnostics Helper

A Neovim plugin that enhances the default diagnostics experience with features like:

- **Debounced floating diagnostics windows** that appear after hovering for a customizable period
- **Copy diagnostics to clipboard** with convenient key mappings
- **Formatted diagnostic messages** with severity levels and line numbers for better readability

## Why
Virtual text in NeoVim can get very long, and it also doesn't wrap around the terminal, so often times you'll get text that runs off of the screen, especially on laptops
With this plugin you'll be able to read the diagnostic warning, and copy it to your clipboard

## What
From This:
<img width="574" alt="Screenshot 2025-04-03 at 3 15 41 PM" src="https://github.com/user-attachments/assets/b9e94638-dddb-44e7-996b-cda1d1f383ad" />

To This:
<img width="754" alt="Screenshot 2025-04-03 at 3 14 29 PM" src="https://github.com/user-attachments/assets/8feaf1c0-429a-4c5b-b11e-1c9520a816d7" />

Note: Use this to fully disable virtual text from your lsp-config
```lua
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics.virtual_text = false;
    end,
  },
```

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "ifneq/hover-diagnostic.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- Optional custom configuration
  },
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "ifneq/hover-diagnostic.nvim",
  config = function()
    require("diagnostics-helper").setup({
      -- Optional custom configuration
    })
  end
}
```

## Configuration

Here's the default configuration with all available options:

```lua
require("diagnostics-helper").setup({
  debounce_time = 1000, -- Time delay in ms before showing hover diagnostics
  severity_map = {
    [vim.diagnostic.severity.ERROR] = "err",
    [vim.diagnostic.severity.WARN] = "warn",
    [vim.diagnostic.severity.INFO] = "info",
    [vim.diagnostic.severity.HINT] = "hint",
  },
  keymaps = {
    copy_current = "<Leader>yy", -- Copy diagnostics at cursor 
    copy_all = "<Leader>ya",     -- Copy all diagnostics in file
  },
  float_opts = {
    border = "rounded",
    source = true,
    focusable = true,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    prefix = " ",
  }
})
```

## Features

### Debounced Diagnostic Windows

The plugin shows diagnostics in a floating window after hovering over an error for a configurable amount of time (default: 1000ms). This prevents diagnostic windows from popping up too aggressively.

### Copy Diagnostics to Clipboard

- `<Leader>yy`: Copy diagnostics at cursor position to clipboard
- `<Leader>ya`: Copy all diagnostics in the current file to clipboard

The copied diagnostics include:
- Severity level (err, warn, info, hint)
- Source of diagnostic (e.g., "eslint:")
- Error message
- Line number

### Example Output

When copying diagnostics, you'll get formatted output like:

```
[err] tsserver: Cannot find name 'foobar'. (Line 42)
[warn] eslint: 'useState' is defined but never used. (Line 15)
```

## License

MIT
