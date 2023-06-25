[app]
%{ for ip in app_servers ~}
appserver ansible_host=${ip}
%{ endfor ~}

[db]
%{ for ip in db_servers ~}
dbserver ansible_host=${ip}
%{ endfor ~}
