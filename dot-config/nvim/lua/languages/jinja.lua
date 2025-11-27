-- Function to correctly detect mixed filetype Jinja files

local function detect_jinja_filetype()
  local filename = vim.fn.expand("%:t")

  -- Exit early if we don't have a filename
  if not filename or filename == "" then
    return
  end

  -- Check if file ends with .j2, .jinja, or .jinja2
  local is_jinja = filename:match("%.j2$") or filename:match("%.jinja2?$")
  if not is_jinja then
    return
  end

  -- From vim.fn.fnamemodify docs:
  -- Modifiers:
  --   :p    Expand to full path
  --   :h    Head (last path component removed)
  --   :t    Tail (last path component only)
  --   :r    Root (one extension removed)
  --   :e    Extension only

  -- Remove .j2/.jinja/.jinja2
  local j2_removed = vim.fn.fnamemodify(filename, ":r")
  -- Get the extension after removing .j2
  local base_ft_ext = vim.fn.fnamemodify(j2_removed, ":e")

  -- If extension is empty the file must just be jinja like template.j2
  if base_ft_ext == "" then
    vim.bo.filetype = "jinja"
  else
    -- Set filetype sh.jinja (or html.jinja, etc.)
    vim.bo.filetype = base_ft_ext .. ".jinja"
  end
end

-- Use autocommand to detect jinja files
-- Check filename in callback to handle multiple extensions like file.sh.j2
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  -- Match files that might end with .j2, .jinja, or .jinja2 (including those with other extensions)
  pattern = { "*.j2", "*.jinja", "*.jinja2", "*.*.j2", "*.*.jinja", "*.*.jinja2" },
  callback = detect_jinja_filetype,
  desc = "Detect jinja filetype and set composite filetype like sh.jinja",
})
