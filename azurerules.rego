package azurerules

import input as tfplan

default allow  = false
allow = true {
    not storage_account
}
storage_account = false {
    count(sa_https) != 0
}
sa_https[resource_name] {
sa_https_access := tfplan[_]
    resource_name := sa_https_access.address
sa_https_access.type == "azurerm_storage_account"
    sa_https_access.change.after.enable_https_traffic_only == false
}

storage_account = false {
    count(sc_type) != 0
}
sc_type[resource_name] {
    sc_type_access := tfplan[_]
    resource_name := sc_type_access.address
    sc_type_access.type == "azurerm_storage_container"
    sc_type_access.change.after.container_access_type != "private"
}
