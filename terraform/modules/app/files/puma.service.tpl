[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=appuser
WorkingDirectory=/home/appuser/reddit
ExecStart=/bin/bash -lc 'puma -b tcp://0.0.0.0:${app_port}' 
Environment=DATABASE_URL=${database_ip_address}:${mongodb_port}
Restart=always

[Install]
WantedBy=multi-user.target
