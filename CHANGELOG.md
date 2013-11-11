# 2.1.1:
* add tailor cane, kitchen testing
* chefspecs for chefspec 3.0 
* allow ddns update in subnet  (pull request #13 from simonjohansson)
* fixes for chef11 compat
* fix version check in DSL condition
* update service notifications to new format

# 2.0.0:

* Initial public release
* Restucture entire cookbook for better reusability
* Remove Internal/non-public dependencies  
* Fix: master/slave replication issues
* Fix: LWRP notification method
* Add minimal spec's for libraries
* New: examples directory with databags and environments
* New: configurable bag lookups for dhcp/dns bags
* New: Group host list support
* New: Defaults to mac address as hostname for non registered clients
* NEw: Defines global defaults in default attributes
