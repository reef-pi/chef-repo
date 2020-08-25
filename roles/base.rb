name 'base'
run_list 'recipe[reef-pi::core]', 'recipe[reef-pi::node_exporter]'
