---

app:
  hosts:
    appserver:
%{ for index, ip in app_servers ~}
      ansible_host: ${ip}
%{ endfor ~}

db:
  hosts:
    dbserver:
%{ for index, ip in db_servers ~}
      ansible_host: ${ip}
%{ endfor ~}
