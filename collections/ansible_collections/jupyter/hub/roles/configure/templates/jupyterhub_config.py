c.JupyterHub.ssl_cert = "{% if cert_file is defined %}{{ cert_file }}{% else %}/etc/ssl/private/cert.pem{% endif %}"
c.JupyterHub.ssl_key = "{% if key_file is defined %}{{ key_file }}{% else %}/etc/ssl/private/key.pem{% endif %}"

c.JupyterHub.authenticator_class = 'ldapauthenticator.LDAPAuthenticator'
c.LDAPAuthenticator.use_ssl =  True
c.LDAPAuthenticator.server_port =  636
c.LDAPAuthenticator.server_address =  "{% if ldap_server_address is defined %}{{ ldap_server_address }}{% else %}0.0.0.0{% endif %}"
c.LDAPAuthenticator.lookup_dn_search_user = '{% if ldap_bind_user is defined %}{{ ldap_bind_user }}{% else %}CN=admin,{{ ldap_organization_upper }}{% endif %}'
c.LDAPAuthenticator.lookup_dn_search_password = '{{ ldap_password }}'
c.LDAPAuthenticator.bind_dn_template = '{% if ldap_bind_dn_template is defined %}{{ ldap_bind_dn_template }}{% else %}UID={username},OU=people,{{ ldap_organization_upper }}{% endif %}'
c.LDAPAuthenticator.lookup_dn = True
c.LDAPAuthenticator.search_filter = '(&(objectClass=posixAccount)(uid={username}))'
c.LDAPAuthenticator.username_pattern = '[a-zA-Z0-9_.][a-zA-Z0-9_.-]{0,252}[a-zA-Z0-9_.$-]?'
c.LDAPAuthenticator.lookup_dn_user_dn_attribute = 'uid'
c.LDAPAuthenticator.user_attribute = 'uid'
c.LDAPAuthenticator.escape_userdn = False
c.LDAPAuthenticator.user_search_base = '{% if ldap_user_search_base is defined %}{{ ldap_user_search_base }}{% else %}OU=people,{{ ldap_organization_upper }}{% endif %}'

c.JupyterHub.db_url = 'postgresql://{{ jupyterhub_user }}:{{ jupyterhub_user_password }}@{{ inventory_hostname }}:5432/jupyterhub'
c.JupyterHub.cookie_secret_file = '/etc/jupyterhub/jupyterhub_cookie_secret'
c.JupyterHub.bind_url = "https://{{ inventory_hostname }}:8443"
c.JupyterHub.hub_ip = ''
c.JupyterHub.ip = ''
c.JupyterHub.port = 8443
c.JupyterHub.spawner_class = "yarnspawner.YarnSpawner"
c.YarnSpawner.mem_limit = "2 G"
c.YarnSpawner.cpu_limit = 1
c.YarnSpawner.principal = "{{ keytab_user_jupyter }}/{{ inventory_hostname }}"
c.YarnSpawner.keytab = "{{ keytab_folder }}/{{ keytab_user_jupyter }}.keytab"
c.YarnSpawner.default_url = "/lab"
c.YarnSpawner.prologue = 'source /opt/miniforge/miniforge/bin/activate jupyterlab'
c.YarnSpawner.cmd = 'python -m yarnspawner.jupyter_labhub'
c.ConfigurableHTTPProxy.command = ['configurable-http-proxy','ssl-protocol','TLSv1_2']
