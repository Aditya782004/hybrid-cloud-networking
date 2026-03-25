pipeline{
  agent any
  stages{
    stage("multibranch-check"){
      steps{
        sh 'echo multibranch pipeline works'
      }
    }
      stage("Git Checkout"){
        steps{
          git branch: 'main'
            url: 'https://github.com/Aditya782004/hybrid-cloud-networking'
        }
      }
      stage("Git Checkout"){
        steps{
          echo 'cehckout completed'
      }
    }
  }
}

