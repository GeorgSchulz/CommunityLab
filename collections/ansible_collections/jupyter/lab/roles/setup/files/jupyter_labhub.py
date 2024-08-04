import os
import json
import requests

from jupyterhub.services.auth import HubOAuthCallbackHandler
from jupyterhub.services.auth import HubOAuth
from jupyterhub.utils import random_port, url_path_join
from traitlets import default

try:
    from jupyterlab.labhubapp import SingleUserLabApp
except ImportError:
    raise ImportError("You must have jupyterlab installed for this to work")

# Borrowed and modified from jupyterhub/batchspawner:
# https://github.com/jupyterhub/batchspawner/blob/d1052385f245a3c799c5b81d30c8e67f193963c6/batchspawner/singleuser.py
class YarnSingleUserLabApp(SingleUserLabApp):
    @default('port')
    def _port(self):
        return random_port()

    def start(self):
        self.oauth_callback_handler_class = HubOAuthCallbackHandler

        hub_auth = HubOAuth()
        url = url_path_join(hub_auth.api_url, "yarnspawner")
        headers = {"Authorization": f"token {hub_auth.api_token}"}
        r = requests.post(
               url,
               headers=headers,
               json={"port": self.port},
         )
        super().start()


def main(argv=None):
    # Set configuration directory to something local if not already set
    for var in ['JUPYTER_RUNTIME_DIR', 'JUPYTER_DATA_DIR']:
        if os.environ.get(var) is None:
            if not os.path.exists('.jupyter'):
                os.mkdir('.jupyter')
            os.environ[var] = './.jupyter'
    application_user = os.environ["USER"]
    os.environ["JUPYTERHUB_OAUTH_ACCESS_SCOPES"] = f'["access:servers!server={application_user}/", "access:servers!user={application_user}"]'
    return YarnSingleUserLabApp.launch_instance(argv)


if __name__ == "__main__":
    main()
