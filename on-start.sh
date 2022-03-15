#!/bin/bash

set -e

sudo -u ec2-user -i <<'EOF'

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh

cat >>/home/ec2-user/.jupyter/jupyter_notebook_config.py <<EOC
c.ServerProxy.servers = {
  'vscode': {
    'command': ['code-server', '--auth none', '--port {port}']
    'timeout': 30
    'launcher_entry':{'title': 'Code Server'}
  }
}
EOC

source /home/ec2-user/anaconda3/bin/activate JupyterSystemEnv
pip install jupyter-server-proxy
jupyter labextension install @jupyterlab/server-proxy
conda deactivate
EOP
