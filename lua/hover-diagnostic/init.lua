local M = {}

-- Default configuration
M.defaults = {
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
}

-- Store the last formatted diagnostic messages
local last_diagnostics_list = ""

function M.setup(opts)
  -- Merge user config with defaults
  opts = vim.tbl_deep_extend("force", M.defaults, opts or {})
  
  -- Set keybindings for copying diagnostics
  vim.keymap.set("n", opts.keymaps.copy_current, function()
    if last_diagnostics_list ~= "" then
      vim.fn.setreg("+", last_diagnostics_list) -- Copy to system clipboard
      vim.notify("Diagnostics copied to clipboard!", vim.log.levels.INFO)
    else
      vim.notify("No diagnostics available.", vim.log.levels.WARN)
    end
  end, { silent = true, desc = "Copy diagnostics at cursor" })
  
  vim.keymap.set("n", opts.keymaps.copy_all, function()
    local all_diagnostics = vim.diagnostic.get(0) -- Get all diagnostics in the current buffer
    if #all_diagnostics > 0 then
      local formatted_messages = {}
      for _, diag in ipairs(all_diagnostics) do
        local severity = opts.severity_map[diag.severity] or "Unknown"
        local source = diag.source and (diag.source .. ": ") or "" -- Include source if available
        local lnum = diag.lnum + 1 -- Convert 0-based line number to 1-based
        table.insert(
          formatted_messages,
          string.format("[%s] %s%s (Line %d)", severity, source, diag.message, lnum)
        )
      end
      local all_file_diagnostics_list = table.concat(formatted_messages, "\n")
      vim.fn.setreg("+", all_file_diagnostics_list) -- Copy to system clipboard
      vim.notify("All file diagnostics copied to clipboard!", vim.log.levels.INFO)
    else
      vim.notify("No diagnostics found in file.", vim.log.levels.WARN)
    end
  end, { silent = true, desc = "Copy all file diagnostics" })

  -- Time delay before showing hover diagnostics (in milliseconds)
  local debounce_timer = nil

  -- Show floating diagnostics with debounce
  vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    callback = function()
      -- Cancel the previous timer if it exists
      if debounce_timer then
        debounce_timer:stop()
      end

      -- Start a new timer
      debounce_timer = vim.defer_fn(function()
        -- Get diagnostics under the cursor
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })

        if #diagnostics > 0 then
          -- Format diagnostics as a list
          local formatted_messages = {}
          for _, diag in ipairs(diagnostics) do
            local severity = opts.severity_map[diag.severity] or "Unknown"
            local source = diag.source and (diag.source .. ": ") or "" -- Include source if available
            table.insert(formatted_messages, string.format("[%s] %s%s", severity, source, diag.message))
          end
          last_diagnostics_list = table.concat(formatted_messages, "\n") -- Store list as new lines

          -- Open floating window with diagnostic
          vim.diagnostic.open_float(nil, opts.float_opts)
        end
      end, opts.debounce_time)
    end,
  })
end

return M
