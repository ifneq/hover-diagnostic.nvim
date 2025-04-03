# Diagnostics Helper

A Neovim plugin that enhances the default diagnostics experience with features like:

- **Debounced floating diagnostics windows** that appear after hovering for a customizable period
- **Copy diagnostics to clipboard** with convenient key mappings
- **Formatted diagnostic messages** with severity levels and line numbers for better readability

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "yourusername/diagnostics-helper.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- Optional custom configuration
  },
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "yourusername/diagnostics-helper.nvim",
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
