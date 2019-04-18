# ANSIBLE : les rôles

## <u>Introduction:</u>
Un rôle est une une structure arborescente. Il permet de décomposer les actions effectuées dans un YAML global.

Cette structure est sous-divisée en répertoires correspondant chacun à un module:

- <u>files:</u> liste de fichiers à copier
- <u>templates:</u> fichiers template Jinja
- <u>tasks: </u>liste de tâches à exécuter
- <u>handlers:</u> tâches qui vont s'exécuter lors de changement
- <u>vars : </u>déclaration de variables
- <u>defaults:</u> valeurs par défaut
- <u>meta:</u> dépendances du rôle

---

## <u>Ansible Galaxy</u>
- L'instruction suivante permet la création d'un rôle en générant un squelette complet pouvant être modifié:

```
ansible-galaxy init nom_du_rôle
```

- Le squelette généré se présente ainsi (exemple ici pour un rôle appelé "apache"):

<img src='https://www.hebergeur-image.com/upload/95.128.149.242-5c5c611f89f1d.jpg'/>


Pour lancer le rôle, il faut créer le playbook (`.yml`) et l'inventaire (`.inv`) (qui contient la liste de machine) à la racine du répertoire du rôle. 

<img src='https://www.hebergeur-image.com/upload/95.128.149.242-5c5d57bb7038c.jpg'/>

On appelle le rôle (apache ici en exemple) dans le playbook.

Il faudra ensuite exécuter le playbook : 

```
ansible-playbook -b -i inventaire.inv playbook.yml
```

- "-b" : commande en root


## <u>/tasks :</u>

Dans le répertoire /tasks, on modifie le main.yml qui listera les instructions à exécuter.

On y décompose les commandes que l'on écrirait normalement dans le prompt: 

- Exemple:
```
yum install nom_du_service
yum start nom_du_service
```

- Donnerait dans le tasks/main.yml:


```
- name: "nom/commentaire de la tâche 1"
  yum:                         
    name: "nom_du_service à installer"
    state: "present"
- name: "nom/commentaire de la tâche 2"
service:
name: "nom_du_service"
state: "started"
enabled: yes
```
Il est nécessaire de respecter correctement les indentations dans le fichier afin d'éviter les erreurs de compilation.


## <u>/handlers :</u>

Lors de changement, les tâches contenues dans le handlers/main.yml seront exécutées. Elles sont appelées via la commande `notify` dans le playbook à la racine du rôle. 

- Par exemple, pour un redémarrage de service:

```
- name: "nom/commentaire de la tâche"
  service: 
    name: "nom du service"
    stated: "started"
```
- Qui correspondrait dans un prompt à:

```
systemctl restart nom_du_service
```

## <u>/templates :</u>

Par défaut, Ansible utilise `JinJa2` pour générer les templates.

Ils sont créés avec l'extension `.j2`. Ils rendent dynamiques la récupération des informations.
Le playbook exécute la structure écrite dans le .j2. Les variables magiques "{{ variable_magique }}" permettent de récupérer des informations des machines de l'inventaire.


Ces informations sont envoyées dans un fichier créé sur la machine cible.


Dans un fichier Jinja, il est possible d'utiliser les mécanismes telsques les boucles :

```
{% for element in liste_element %}
le contenu de la variable element est le suivant: {{element}}
{% endfor %}
```

### <u>Création de variables propres:</u>
Il est possible de créer ses propres variables à moustaches.

Un exemple de code: 
- <u>Dans le playbook:</u>

```
- name: "Generate html file for each host"
  hosts: all
  gather_facts: yes
  remote_user: "nom du user auquel on se connecte" 
  vars:
    host_inventory: "nom_de_la_machine_cible"
    inventory_dir: "/var/www/html/nom_au_choix"
  tasks:
   - name: "Create template directory"
     file:
       path: "{{inventory_dir}}"
       owner: "apache"
       group: "apache"
       mode: "0755"
       state: "directory"
     delegate_to: "{{host_inventory}}"
     run_once: yes 
   - name: "html file generation"
     template:
       src: "machine.html.j2"
       dest: "{{inventory_dir}}/{{inventory_hostname}}.html"
     delegate_to: "{{host_inventory}}"
```

- <u>Codage dans le .j2 :</u>

Variable pour récupéree nom de machine:
```
Machine {{ inventory_hostname }}
```

Variable de la direction pour la création de fichier de récupération d'info:
```
 {{ inventory_dir }}
```

### <u>Variables d'environnements fixes "magiques"</u>

Il existe des variables prédéfinies et utilisables.

- Variable qui récupère la capacité du disque dur:
```
{{ ansible_devices.sda. size}}
```

- Variable pour récupérer la mémoire totale :
```
{{ ansible_memtotal_mb }}
```

###  EN COURS !