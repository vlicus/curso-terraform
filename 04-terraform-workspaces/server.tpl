# Configuración del Servidor: ${project}-${workspace}-server-${server_id}
## Generado automáticamente por Terraform

[server]
id=${server_id}
name=${project}-${workspace}-server-${server_id}
environment=${workspace}
project=${project}

[resources]
cpu=${cpu}
memory=${memory}
storage=${storage}

[features]
monitoring=${monitoring ? "enabled" : "disabled"}
backup=${backup ? "enabled" : "disabled"}
%{ if workspace == "prod" ~}
ssl=enabled
debug=disabled
log_level=ERROR
%{ else ~}
ssl=disabled
debug=enabled
log_level=DEBUG
%{ endif ~}

[environment_specific]
description=${environment}
%{ if workspace == "prod" ~}
max_connections=1000
cache_size=512MB
session_timeout=3600
%{ else ~}
%{ if workspace == "staging" ~}
max_connections=500
cache_size=256MB
session_timeout=1800
%{ else ~}
max_connections=100
cache_size=128MB
session_timeout=900
%{ endif ~}
%{ endif ~}

[metadata]
created_by=terraform
workspace=${workspace}
server_number=${server_id}