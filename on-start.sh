#!/bin/bash

set -e

sudo -u ec2-user -i <<'EOF'

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh

cat >>/home/ec2-user/.jupyter/jupyter_notebook_config.py <<EOC
c.ServerProxy.servers = {
  'code-server': {
    'command': [
      'code-server',
        '--auth=none',
        '--disable-telemetry',
        '--bind-addr=localhost:{port}',
        '--user-data-dir=/home/ec2-user/SageMaker/.vscode'
    ],
    'timeout': 20,
    'launcher_entry': {
      'title': 'VS Code'
    }
  }
}
EOC

source /home/ec2-user/anaconda3/bin/activate JupyterSystemEnv
pip install jupyter-server-proxy
jupyter labextension install @jupyterlab/server-proxy
conda deactivate

EOF

yum install -y htop

reboot
