name 'base'
run_list 'recipe[foundation]', 'recipe[foundation::node_exporter]'
