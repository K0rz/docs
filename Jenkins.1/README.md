# README Jenkins
Précurseurs a Jenkins : Outils de versionning, Tests Unitaires
Travis integre un jeu de test python et + : intégration git 
Python vagrant 
deux manière de créer une chaine : 
ensemble de machine avec un role ou avec docker, chaque conteneur avec son propre role et kubbernette
Inspection de co et compilation

## INTEGRATION CONTINUE
exigences : Reporting, release en continu et réactif face aux changements
Changement en intégration ontinue : commit régulier et ponctuel
Consensus sur la fréquence au moins une fois par jour
ce qui inclu forcément : 
    code versionné : GIT
    TEst auto : PHPUnit
    Serveur d'IC : Jenkins, Travis, Bamboo
    Mesure de la qualité du code : SonarQube
code propre = commentary


### Comment ca marche dedans ?
4 gestionnaires : Build, Test, SCM, Notifs

### Exemple de Code :
```
node {  
    stage('Checkout') { 
        echo 'stage Checkout'
        git branch: 'develop', url: 'http://vps635270.ovh.net/alex/jenkins-alexgood.git'
    }
    stage('Build') {
        echo 'stage Build'
        withMaven(maven:'mav',jdk:'jdk8'){
            sh "mvn clean verify"
        }
        step([$class:'JUnitResultArchiver',testResults:'target/surefire-reports/*xml'])
        step([$class:'JUnitResultArchiver',testResults:'target/failsafe-reports/*xml'])
        dir('target'){
           archive '*.jar'
       }
        stash name : 'binary', includes : 'target/*.jar'
    }
    stage('Deploy Docker') { 
        echo 'Begin Docker'
        sh 'sudo docker build -t alex/tomcat .'
        echo 'build done'
        sh 'sudo docker run -d -p 1234:8080 -v /var/lib/jenkins/workspace/pipeline1/target:/usr/local/tomcat/webapps/target --name tomcato alex/tomcat'
        echo 'run done'
    }
    stage('Deploy') { 
        echo 'stage Deploy'
    }
}
```

Toujours penser a mettre le user jenkins dans le groupe wheel ainsi que lui donner le NOPASSWD dans sudo visudo comme pour le ansibleuser
