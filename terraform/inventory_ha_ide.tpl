all:
  children:
    hub1:
      hosts: "hub1.${domain}"
      vars:
        keepalived_state: MASTER
        keepalived_virtual_router_id: 80
        keepalived_priority: 100
    hub2:
      hosts: "hub2.${domain}"
      vars:
        keepalived_state: BACKUP
        keepalived_virtual_router_id: 80
        keepalived_priority: 99
    master1:
      hosts: "master1.${domain}"
      vars:
        zookeeper_id: 1
    master2:
      hosts: "master2.${domain}"
      vars:
        zookeeper_id: 2
    master3:
      hosts: "master3.${domain}"
      vars:
        zookeeper_id: 3
    worker1:
      hosts: "worker1.${domain}"
      vars:
        patroni_id: 1
    worker2:
      hosts: "worker2.${domain}"
      vars:
        patroni_id: 2
    worker3:
      hosts: "worker3.${domain}"
      vars:
        patroni_id: 3
    security1:
      hosts: "security1.${domain}"
    security2:
      hosts: "security2.${domain}"
    hubs:
      children:
        hub1:
        hub2:
      vars:
        service_user: "{{ jupyterhub_user }}"
        service_name: "JupyterHub"
        service_uid: "5001"
        service_group: "{{ jupyterhub_group }}"
        service_gid: "4001"
        tls_user: "{{ jupyterhub_user }}"
        tls_group: "{{ jupyterhub_group }}"
        keytab_group: "{{ jupyterhub_group }}"
    loadbalancers:
      children:
        hub1:
        hub2:
      vars:
        hetzner_token: "${hetzner_token}"
        hetznerdns_token: "${hetznerdns_token}"
        haproxy_admin_password: "changeit"
        haproxy_pem_file: "/etc/ssl/private/haproxy.pem"
    namenode1:
      children:
        master1:
    namenode2:
      children:
        master2:
    namenode3:
      children:
        master3:
    namenodes:
      children:
        namenode1:
        namenode2:
        namenode3:
      vars:
        service_user: "{{ yarn_user }}"
        service_name: "Apache Hadoop"
        service_uid: "5004"
        service_group: "{{ yarn_group }}"
        service_gid: "4001"
        tls_user: "{{ yarn_user }}"
        tls_group: "{{ yarn_group }}"
    resourcemanager1:
      children:
        master1:
    resourcemanager2:
      children:
        master2:
    resourcemanager3:
      children:
        master3:
    resourcemanagers:
      children:
        resourcemanager1:
        resourcemanager2:
        resourcemanager3:
    zookeeper:
      children:
        master1:
        master2:
        master3:
    datanodes:
      children:
        worker1:
        worker2:
        worker3:
      vars:
        service_user: "{{ yarn_user }}"
        service_name: "Apache Hadoop"
        service_uid: "5004"
        service_group: "{{ yarn_group }}"
        service_gid: "4001"
        tls_user: "{{ yarn_user }}"
        tls_group: "{{ yarn_group }}"
    nodemanagers:
      children:
        worker1:
        worker2:
        worker3:
    spark:
      children:
        worker1:
        worker2:
        worker3:
    postgres:
      children:
        worker1:
        worker2:
        worker3:
      vars:
        cert_file_postgres: "/etc/ssl/private/cert_postgres.pem"
        key_file_postgres: "/etc/ssl/private/key_postgres.pem"
        chain_file_postgres: "/etc/ssl/private/chain_postgres.pem"
        certs_dest_postgres:
          - "cert_postgres.pem"
          - "chain_postgres.pem"
          - "key_postgres.pem"
        postgres_user_password: "changeit"
        repl_user_password: "changeit"
        postgres_schemes:
          - username: "postgres"
            database: "postgres"
            password: "{{ postgres_user_password }}"
            port: 5432
            hostname: "*"
          - username: "jupyterhub"
            database: "jupyterhub"
            password: "{{ jupyterhub_user_password }}"
            port: 5432
            hostname: "*"
            scheme: "jupyterhub"
    jupyterlab:
      children:
        worker1:
        worker2:
        worker3:
    ldap1:
      children:
        security1:
    ldap2:
      children:
        security2:
    ldap:
      children:
        ldap1:
        ldap2:
      vars:
        service_user: "{{ ldap_user }}"
        service_name: "OpenLdap"
        service_uid: "5001"
        service_group: "{{ ldap_group }}"
        service_gid: "4001"
        tls_user: "{{ ldap_user }}"
        tls_group: "{{ ldap_group }}"
    kerberos1:
      children:
        security1:
    kerberos2:
      children:
        security2:
    kerberos:
      children:
        kerberos1:
        kerberos2:
      vars:
        realm_password: "changeit"
  vars:
    molecule_deployment: false
    custom_inventory_file: false
    self_signed_certificates: false
    kerberos_external: false
    tls_external: false
    ldap_external: false
    ldap_user: "openldap"
    ldap_group: "openldap"
    jupyterhub_user: "jupyterhub"
    jupyterhub_group: "jupyterhub"
    hdfs_user: "hdfs"
    hdfs_group: "hadoop"
    yarn_user: "yarn"
    yarn_group: "hadoop"
    domain: "${domain}"
    certs_source: 
      - "/opt/letsencrypt/{{ inventory_hostname }}/cert1.pem"
      - "/opt/letsencrypt/{{ inventory_hostname }}/chain1.pem"
      - "/opt/letsencrypt/{{ inventory_hostname }}/privkey1.pem"
    certs_dest:
      - "cert.pem"
      - "chain.pem"
      - "key.pem"
    certs_mode:
      - "0660"
      - "0660"
      - "0400"
    cert_file: "/etc/ssl/private/cert.pem"
    key_file: "/etc/ssl/private/key.pem"
    keystore_file: "/etc/ssl/private/{{ inventory_hostname }}.jks"
    keystore_password: "changeit"
    truststore_file: "/etc/ssl/certs/truststore.jks"
    truststore_password: "changeit"
    jupyterhub_user_password: "changeit"
    ide_services_group: "hadoop"
    ide_users_group: "ide_users"
    ide_users_gid: "5001"
    keytab_user_hdfs: "{{ hdfs_user }}"
    keytab_user_yarn: "{{ yarn_user }}"
    keytab_user_journalnode: "{{ journalnode_user }}"
    keytab_user_jupyter: "{{ jupyterhub_user }}"
    keytab_user_http: "HTTP"
    ldap_organization: "dc={{ domain.split('.').0 }},dc={{ domain.split('.').1 }}"
    ldap_server_address: "{% for host in groups.ldap | shuffle %}ldaps://{{ host }}:636{% if not loop.last %},{% endif %}{% endfor %}"
    ldap_bind_user: "cn=admin,{{ ldap_organization }}"
    ldap_password: "changeit"
    ldap_user_search_base: "ou=people,{{ ldap_organization }}"
    ldap_group_search_base: "ou=groups,{{ ldap_organization }}"
    ldap_bind_dn_template: "uid={username},{{ ldap_user_search_base }}"
    ldap_replication_user: "cn=replicator,{{ ldap_organization }}"
    ldap_replication_password: "changeit"
    ldap_kdc_service_password: "changeit"
    ldap_kadmin_service_password: "changeit"
    realm: "COMMUNITY.LAB"
    keytab_folder: "/etc/keytabs"
    hadoop_nameservice: "communitylab"
    jupyterhub_domain_ip: true
    postgres_host: "{{ jupyterhub_domain_ip_address }}"
