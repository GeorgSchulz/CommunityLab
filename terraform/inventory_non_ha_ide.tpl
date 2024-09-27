all:
  children:
    hub1:
      hosts: "hub1.${domain}"
    master1:
      hosts: "master1.${domain}"
      vars:
        zookeeper_id: 1
    worker1:
      hosts: "worker1.${domain}"
    worker2:
      hosts: "worker2.${domain}"
    worker3:
      hosts: "worker3.${domain}"
    security1:
      hosts: "security1.${domain}"
    hubs:
      children:
        hub1:
      vars:
        service_user: "{{ jupyterhub_user }}"
        service_name: "JupyterHub"
        service_uid: "5001"
        service_group: "{{ jupyterhub_group }}"
        service_gid: "4001"
        tls_user: "{{ jupyterhub_user }}"
        tls_group: "{{ jupyterhub_group }}"
        keytab_group: "{{ jupyterhub_group }}"
    postgres:
      children:
        hub1:
      vars:
        postgres_schemes:
          - username: "jupyterhub"
            database: "jupyterhub"
            password: "{{ jupyterhub_user_password }}"
            port: 5432
            hostname: "*"
            scheme: "jupyterhub"
    namenode1:
      children:
        master1:
    namenodes:
      children:
        namenode1:
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
    resourcemanagers:
      children:
        resourcemanager1:
    zookeeper:
      children:
        master1:
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
    jupyterlab:
      children:
        worker1:
        worker2:
        worker3:
    ldap1:
      children:
        security1:
    ldap:
      children:
        ldap1:
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
    kerberos:
      children:
        kerberos1:
      vars:
        realm_password: "changeit"
  vars:
    ide_ha_setup: false
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
    keytab_user_jupyter: "{{ jupyterhub_user }}"
    keytab_user_http: "HTTP"
    ldap_organization: "dc={{ domain.split('.').0 }},dc={{ domain.split('.').1 }}"
    ldap_server_address: "ldaps://{{ groups.ldap1[0] }}:636"
    ldap_bind_user: "cn=admin,{{ ldap_organization }}"
    ldap_password: "changeit"
    ldap_user_search_base: "ou=people,{{ ldap_organization }}"
    ldap_group_search_base: "ou=groups,{{ ldap_organization }}"
    ldap_bind_dn_template: "uid={username},{{ ldap_user_search_base }}"
    realm: "COMMUNITY.LAB"
    keytab_folder: "/etc/keytabs"
    hadoop_nameservice: "communitylab"
    postgres_host: ""
