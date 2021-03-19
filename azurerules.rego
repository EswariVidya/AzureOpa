package azurerules

import input as tfplan

default allow  = false
allow = true {
    count(nsg_inbound) == 0
}

nsg_rule = false {
    count(nsg_inbound) !=0
}
nsg_inbound[resource_name] {
    nsg_rules1 := tfplan[_]
    resource_name := nsg_rules1.address
    nsg_rules1.type == "azurerm_network_security_group"
    nsg_rules1.change.after.security_rule[_].access == "Allow"
    nsg_rules1.change.after.security_rule[_].direction == "Inbound"
    any([nsg_rules1.change.after.security_rule[_].destination_port_range == "22",
        nsg_rules1.change.after.security_rule[_].destination_port_range == "3389",
        nsg_rules1.change.after.security_rule[_].destination_port_range == "*"])
}

#allow = true {
#    not storage_account
#}
#storage_account = false {
#    count(sa_https) != 0
#}
#sa_https[resource_name] {
#    sa_https_access := tfplan[_]
#    resource_name := sa_https_access.address
#    sa_https_access.type == "azurerm_storage_account"
#    sa_https_access.change.after.enable_https_traffic_only == false
#}

#storage_account = false {
#    count(sc_type) != 0
#}
#sc_type[resource_name] {
#    sc_type_access := tfplan[_]
#    resource_name := sc_type_access.address
#    sc_type_access.type == "azurerm_storage_container"
#    sc_type_access.change.after.container_access_type != "private"
#}
allow = true {
    not sql_server_firewall
}
sql_server_firewall = false {
    count(sqlserver_startip) != 0
}
sqlserver_startip[resource_name] {
    sql_ip := tfplan[_]
    resource_name := sql_ip.address
   sql_ip.type == "azurerm_sql_firewall_rule"
    any([sql_ip.change.after.start_ip_address == "0.0.0.0",
    sql_ip.change.after.end_ip_address ==  "0.0.0.0",
    sql_ip.change.after.end_ip_address == "255.255.255.255"])
}
