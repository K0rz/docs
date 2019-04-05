Rôle firewall_open80
=========
Configure firewalld pour lui faire accepter les connexions sur le port **80** en **TCP**
et activer le service **http**.

Prérequis
------------
Succès de `setup_user.yml` et `install-apache-roles.yml`.

Dépendances
------------
L'usage de ce rôle suit **setup_user** et **apache**.

Example Playbook
----------------
Dans `install-apache-roles.yml` :
```yaml
    - name: "Firewall ouverture"
      hosts: apache_omega_user
      roles:
        - role: "firewall_open80"
```