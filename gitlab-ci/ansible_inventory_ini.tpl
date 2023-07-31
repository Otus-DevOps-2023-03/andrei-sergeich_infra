[gitlab]
%{ for ip in gitlab_servers ~}
gitlabserver ansible_host=${ip}
%{ endfor ~}
