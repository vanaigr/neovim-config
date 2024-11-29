local m = require('mapping')
require('triptych').setup()
m.n('<leader>e', '<cmd>Triptych<cr>')
m.n('<leader>te', '<cmd>tab split<cr><cmd>Triptych<cr>')
