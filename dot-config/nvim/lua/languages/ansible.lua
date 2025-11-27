-- Command to setup and update ansible-language-server because it's not currently publishing to npm
vim.api.nvim_create_user_command("AnsibleLspUpdate", function()
  local home = vim.env.HOME
  local repo_path = home .. "/code/github.com/ansible/vscode-ansible"
  local readme_path = repo_path .. "/README.md"

  -- Check if README.md exists
  if vim.fn.filereadable(readme_path) == 0 then
    vim.notify("vscode-ansible not found. Cloning repository...", vim.log.levels.INFO)

    -- Create directory and clone repo
    local clone_cmd = string.format(
      "mkdir -p %s/code/github.com/ansible && cd %s/code/github.com/ansible && git clone https://github.com/ansible/vscode-ansible.git",
      home,
      home
    )
    local clone_result = vim.fn.system(clone_cmd)

    if vim.v.shell_error ~= 0 then
      vim.notify("Failed to clone repository: " .. clone_result, vim.log.levels.ERROR)
      return
    end

    vim.notify("Repository cloned successfully", vim.log.levels.INFO)
  end

  -- Update and build the language server
  vim.notify("Updating and building ansible-language-server...", vim.log.levels.INFO)

  local update_cmd = string.format(
    "cd %s && git pull --force && cd packages/ansible-language-server && npm rm -g @ansible/ansible-language-server; rm @ansible-language-server.tgz; npm exec -- yarn pack --out '@ansible-language-server.tgz' && npm install -g ./@ansible-language-server.tgz",
    repo_path
  )

  -- Use jobstart to run the command asynchronously and show output
  local job_id = vim.fn.jobstart(update_cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        vim.notify(table.concat(data, "\n"), vim.log.levels.WARN)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("ansible-language-server updated and compiled successfully!", vim.log.levels.INFO)
      else
        vim.notify(
          "Failed to update/compile ansible-language-server (exit code: " .. exit_code .. ")",
          vim.log.levels.ERROR
        )
      end
    end,
  })

  if job_id == 0 then
    vim.notify("Failed to start update job", vim.log.levels.ERROR)
  elseif job_id == -1 then
    vim.notify("Invalid command", vim.log.levels.ERROR)
  end
end, { desc = "Setup and update ansible-language-server" })
