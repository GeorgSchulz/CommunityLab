all:
  children:
    ansible:
      hosts: localhost
    hub1:
      hosts: "hub1.${domain}"
    master1:
      hosts: "master1.${domain}"
      vars:
        zookeeper_id: 1
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
    hubs:
      children:
        hub1:
      vars:
        tls_user: "{{ jupyterhub_user }}"
        postgres_client: true
    masters:
      children:
        master1:
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
      vars:
        tls_user: "{{ ldap_user }}"
  vars:
    keytab_user_hdfs: "{{ hdfs_user }}"
    keytab_user_yarn: "{{ yarn_user }}"
    keytab_user_jupyter: "{{ jupyterhub_user }}"
    keytab_user_http: "HTTP"
