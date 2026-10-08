(function()
  local null_ls = require("null-ls")

  return {
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = { "markdown", "text", "rst", "mdx" },
    generator = null_ls.generator({
      command = "ste",
      args = { "lint", "--format=json" },
      to_stdin = true,
      cwd = function(params)
        if params.bufname == "" then
          return vim.fn.getcwd()
        end
        return vim.fn.fnamemodify(params.bufname, ":p:h")
      end,
      format = "json_raw",
      check_exit_code = function(code)
        return code == 0
      end,
      on_output = function(params)
        if params.err then
          vim.notify("ste: " .. params.err, vim.log.levels.ERROR)
          return {}
        end

        local report = params.output
        if type(report) ~= "table" then
          vim.notify("ste returned an invalid JSON report", vim.log.levels.ERROR)
          return {}
        end

        local findings = report.findings
        if findings == nil or findings == vim.NIL then
          return {}
        end
        if type(findings) ~= "table" then
          vim.notify("ste returned invalid findings", vim.log.levels.ERROR)
          return {}
        end

        local diagnostics = {}
        for _, finding in ipairs(findings) do
          local position = finding.position
          if type(position) == "table"
            and type(position.line) == "number"
            and type(position.col) == "number"
          then
            local line = params.content[position.line] or ""
            local text = type(finding.text) == "string" and finding.text or ""
            local col = math.max(position.col, 1)
            local end_col = math.min(col + math.max(#text, 1), #line + 1)
            if end_col <= col then
              end_col = col + 1
            end

            local message = finding.message or "Writing rule violation"
            if finding.suggest and finding.suggest ~= "" then
              message = message .. " Suggestion: " .. finding.suggest
            end

            table.insert(diagnostics, {
              row = position.line,
              col = col,
              end_col = end_col,
              source = "ste/" .. (finding.rule or "writing"),
              code = finding.rule,
              message = message,
              severity = vim.diagnostic.severity.WARN,
            })
          end
        end
        return diagnostics
      end,
    }),
  }
end)()
