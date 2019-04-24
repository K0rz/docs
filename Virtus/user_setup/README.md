Rôle user_setup
=========
Installe les mises à jour sur le système puis crée un utilisateur **omega**
dans le groupe **wheel** avec un mot de passe. Ajoute au groupe **wheel** la
permission d'exécuter **sudo** sans saisir le mot de passe.

Prérequis
------------
Envoi de la clé publique SSH à `root@apache_omega`.

Dépendances
------------
L'usage de ce rôle précède **apache** et **firewall_open80**.

Example Playbook
----------------
`setup_user.yml` :
```yaml
    - name: "Setup_user"
      hosts: apache_omega_root
      roles:
        - role: "user_setup"
```