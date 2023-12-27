local m = require('mapping')

m.n('<leader>w', '<Plug>CamelCaseMotion_w')
m.n('<leader>b', 'h<Plug>CamelCaseMotion_b')
m.n('<leader>e', '<Plug>CamelCaseMotion_e')
m.n('<leader>ge', '<Plug>CamelCaseMotion_ge')

m.x('<leader>w', '<Plug>CamelCaseMotion_iw')
m.x('<leader>b', 'h<Plug>CamelCaseMotion_b')
m.x('<leader>e', '<Plug>CamelCaseMotion_e')

m.o('<leader>w', '<Plug>CamelCaseMotion_ib')
m.o('<leader>b', '<Plug>CamelCaseMotion_b')
m.o('<leader>e', '<Plug>CamelCaseMotion_e')
