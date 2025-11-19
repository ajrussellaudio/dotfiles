-- Icon provider

local glyphs = {
  docs = '󰈙',
  env = '󰒓',
  eslint = '󰱺',
  git = '',
  github = '',
  node = '',
  pnpm = '',
  prettier = '',
  typescript = '',
  yarn = '󰱺',
}

local hls = {
  boring = 'MiniIconsGrey',
  config = 'MiniIconsYellow',
  declarations = 'MiniIconsPurple',
  dependencies = 'MiniIconsOrange',
  ignore = 'MiniIconsRed',
  javascript = 'MiniIconsYellow',
  lint = 'MiniIconsCyan',
  node = 'MiniIconsGreen',
  typescript = 'MiniIconsBlue',
}

return {
  'nvim-mini/mini.icons',
  version = '*',
  opts = {
    file = {
      ['.github/*'] = { glyph = glyphs.github, hl = hls.boring },
      ['.gitignore'] = { glyph = glyphs.git, hl = hls.ignore },
      ['.gitkeep'] = { glyph = glyphs.git, hl = hls.boring },
      ['.eslintrc.js'] = { glyph = glyphs.eslint, hl = hls.lint },
      ['.node-version'] = { glyph = glyphs.node, hl = hls.config },
      ['.prettierrc'] = { glyph = glyphs.prettier, hl = hls.lint },
      ['.prettierignore'] = { glyph = glyphs.prettier, hl = hls.ignore },
      ['.yarnrc.yml'] = { glyph = glyphs.yarn, hl = hls.config },
      ['eslint.config.js'] = { glyph = glyphs.eslint, hl = hls.lint },
      ['package.json'] = { glyph = glyphs.node, hl = hls.dependencies },
      ['pnpm-lock.yaml'] = { glyph = glyphs.pnpm, hl = hls.dependencies },
      ['pnpm-workspace.yaml'] = { glyph = glyphs.pnpm, hl = hls.config },
      ['README.md'] = { glyph = glyphs.docs, hl = hls.boring },
      ['tsconfig.build.json'] = { glyph = glyphs.typescript, hl = hls.config },
      ['tsconfig.json'] = { glyph = glyphs.typescript, hl = hls.config },
      ['yarn.lock'] = { glyph = glyphs.yarn, hl = hls.dependencies },
    },
    extension = {
      ['d.ts'] = { glyph = glyphs.typescript, hl = hls.declarations },
      ['ts'] = { glyph = glyphs.typescript, hl = hls.typescript },
    },
    directory = {},
  },
}
