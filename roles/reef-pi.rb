name 'reef-pi'
run_list 'role[base]', 'recipe[reef-pi::core]', 'recipe[reef-pi::reef-pi]'
