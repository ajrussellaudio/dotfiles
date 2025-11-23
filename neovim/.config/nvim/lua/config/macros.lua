local esc = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)

vim.api.nvim_create_augroup('JSLogMacro', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'JSLogMacro',
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  callback = function()
    vim.fn.setreg('l', "yiwoconsole.log('" .. esc .. "pa:', " .. esc .. 'pa);' .. esc)
  end,
})
