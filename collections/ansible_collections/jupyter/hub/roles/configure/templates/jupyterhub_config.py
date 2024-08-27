c.JupyterHub.ssl_cert = "{{ cert_file }}"
c.JupyterHub.ssl_key = "{{ key_file }}"

c.Authenticator.allow_all = True
c.JupyterHub.authenticator_class = 'ldapauthenticator.LDAPAuthenticator'
c.LDAPAuthenticator.use_ssl =  True
c.LDAPAuthenticator.server_port = 636
c.LDAPAuthenticator.server_address =  "127.0.0.1" # HAProxy that routes to one or multipe LDAP servers, reason is that multiple LDAP servers can not be configured here
c.LDAPAuthenticator.lookup_dn_search_user = '{{ ldap_bind_user }}'
c.LDAPAuthenticator.lookup_dn_search_password = '{{ ldap_password }}'
c.LDAPAuthenticator.bind_dn_template = '{{ ldap_bind_dn_template }}'
c.LDAPAuthenticator.lookup_dn = True
c.LDAPAuthenticator.search_filter = '(&(objectClass=posixAccount)(uid={username}))'
c.LDAPAuthenticator.username_pattern = '[a-zA-Z0-9_.][a-zA-Z0-9_.-]{0,252}[a-zA-Z0-9_.$-]?'
c.LDAPAuthenticator.lookup_dn_user_dn_attribute = 'uid'
c.LDAPAuthenticator.user_attribute = 'uid'
c.LDAPAuthenticator.escape_userdn = False
c.LDAPAuthenticator.user_search_base = '{{ ldap_user_search_base }}'

c.JupyterHub.db_url = 'postgresql://{{ jupyterhub_user }}:{{ jupyterhub_user_password }}@{{ ansible_fqdn if molecule_deployment is defined and molecule_deployment else inventory_hostname }}:5432/jupyterhub'
c.JupyterHub.cookie_secret_file = '/etc/jupyterhub/jupyterhub_cookie_secret'
c.JupyterHub.bind_url = "https://{{ ansible_fqdn if molecule_deployment is defined and molecule_deployment else inventory_hostname }}:8443"
c.JupyterHub.hub_ip = ''
c.JupyterHub.ip = ''
c.JupyterHub.port = 8443
c.JupyterHub.spawner_class = "yarnspawner.YarnSpawner"
c.YarnSpawner.mem_limit = "2 G"
c.YarnSpawner.cpu_limit = 1
c.YarnSpawner.principal = "{{ keytab_user_jupyter }}/{{ ansible_fqdn if molecule_deployment is defined and molecule_deployment else inventory_hostname }}"
c.YarnSpawner.keytab = "{{ keytab_folder }}/{{ keytab_user_jupyter }}.keytab"
c.YarnSpawner.default_url = "/lab"
c.YarnSpawner.prologue = 'source /opt/miniforge/miniforge/bin/activate jupyterlab'
c.YarnSpawner.cmd = 'python -m yarnspawner.jupyter_labhub'
c.ConfigurableHTTPProxy.command = ['configurable-http-proxy','ssl-protocol','TLSv1_2']

c.Spawner.environment.update(
    {
        "JUPYTERHUB_SINGLEUSER_EXTENSION": "0",
    }
)
