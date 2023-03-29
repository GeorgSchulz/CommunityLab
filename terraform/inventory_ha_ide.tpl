all:
  children:
    ansible:
      hosts: localhost
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
        tls_user: "{{ jupyterhub_user }}"
        postgres_client: true
    masters:
      children:
        master1:
        master2:
        master3:
      vars:
        tls_user: "{{ hdfs_user }}"
    workers:
      children:
        worker1:
        worker2:
        worker3:
      vars:
        tls_user: "{{ hdfs_user }}"
    securities:
      children:
        security1:
        security2:
      vars:
        tls_user: "{{ ldap_user }}"
  vars:
    keytab_user_hdfs: "{{ hdfs_user }}"
    keytab_user_yarn: "{{ yarn_user }}"
    keytab_user_jupyter: "{{ jupyterhub_user }}"
    keytab_user_http: "HTTP"
    keytab_user_journalnode: "{{ journalnode_user }}"
