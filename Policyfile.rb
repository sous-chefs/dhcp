# frozen_string_literal: true

name 'dhcp'
default_source :supermarket

run_list 'test::default'
named_run_list :default, 'test::default'
named_run_list :delete, 'test::default', 'test::config_delete'
named_run_list :remove, 'test::remove_all'

cookbook 'dhcp', path: '.'
cookbook 'test', path: 'test/cookbooks/test'
cookbook 'apparmor'
