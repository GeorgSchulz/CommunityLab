#!/bin/bash

{ echo '{{ ldap_kadmin_service_password }}'; echo '{{ ldap_kadmin_service_password }}'; } | kdb5_ldap_util -D cn=admin,{{ ldap_organization }} stashsrvpw -f /etc/krb5kdc/service.keyfile uid=kadmin-service,{{ ldap_organization }} -w {{ ldap_password }}
{ echo '{{ ldap_kdc_service_password }}'; echo '{{ ldap_kdc_service_password }}'; } | kdb5_ldap_util -D cn=admin,{{ ldap_organization }} stashsrvpw -f /etc/krb5kdc/service.keyfile uid=kdc-service,{{ ldap_organization }} -w {{ ldap_password }}
