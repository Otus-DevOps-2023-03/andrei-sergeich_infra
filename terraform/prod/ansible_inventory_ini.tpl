[app]
%{ for index, ip in app_servers ~}
appserver-${index} ansible_host=${ip}
%{ endfor ~}

[db]
%{ for index, ip in db_servers ~}
dbserver-${index} ansible_host=${ip}
%{ endfor ~}
