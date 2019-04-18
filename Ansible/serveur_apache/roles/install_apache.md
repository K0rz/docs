# Installation apache via module galaxy

On trouve une liste de modules/roles dans https://galaxy.ansible.com.

On l'installe via la commande suivante :
```
$ ansible-galaxy install geerlingguy.apache
```

On créé un playbook .yml qui appelle le rôle téléchargé précédemment :
```
- name: "Apache Installation"
  hosts: vps646618.ovh.net
  roles: 
   - role: "apache"   # correspond au chemin du répertoire téléchargé
```

On exécute le playbook avec la commande suivante :
```
$ ansible-playbook -b -i inventaire.inv playbook.yml 
# inventaire.inv contient la liste des machines où on veut déployer apache
```