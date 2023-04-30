
pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: node
            image: node:14-alpine
            command:
            - cat
            tty: true
          - name: docker
            image: docker:latest
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          volumes:
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock    
        '''
    }
  }
  stages {
    stage('Clone') {
      steps {
        container('maven') {
          git branch: 'main', url: 'https://github.com/belewer/my-app.git'
        }
      }
    }  
    stage('Build-Jar-file') {
      steps {
        container('node') {
          sh 'npm install'
        }
      }
    }
    stage('Build-Docker-Image') {
      steps {
        container('docker') {
          sh 'docker build -t jovilon/my-app:v1 .'
        }
      }
    }
    stage('Login-Into-Docker') {
      steps {
        container('docker') {
            withCredentials([usernamePassword(credentialsId: 'github-jovi', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                sh 'docker login -u $USER -p $PASS'
            }            

      }
    }
    }
     stage('Push-Images-Docker-to-DockerHub') {
      steps {
        container('docker') {
          sh 'docker push jovilon/my-app:v1'
      }
    }
     }
  }
    post {
      always {
        container('docker') {
          sh 'docker logout'
      }
      }
    }
}