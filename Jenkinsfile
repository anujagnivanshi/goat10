#Jenkins file for CI Pipeline
String credentialsID = 'awsCredentials'

try {
    stage('checkout'){
        node {
            cleanWs()
            checkout scm 
        }
    }


    #Run Terraform Init
    stage ('init') {
            node {
            withCredentials(
            [[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsID: credentialsID,
                accesskeyVariable: 'AWS_ACCESS_KEY_ID',
                secretkryVariable: 'AWS_SECRET_KEY_ID'
            ]]
            ){
                ansiColor('xterm') {
                    sh 'terraform init'
                }
            }
        }
    }

    #Run Terraform Plan
    stage ('init') {
        node {
            withCredentials(
            [[
                $class : 'AmazonWebServicesCredentialsBinding',
                credentialsID: credentialsID,
                accesskeyVariable: 'AWS_ACCESS_KEY_ID',
                secretkryVariable: 'AWS_SECRET_KEY_ID'
            ]]
            ){
                ansiColor('xterm') {
                    sh 'terraform plan'
                }
            }

        }
    }

    if (env.BRANCH_NAME == 'master') {

        #Run Terrafrom Apply
        stage('apply') {
            node {
                withCredentials(
                [[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsID: credentialsID,
                    accesskeyVariable: 'AWS_ACCESS_KEY_ID'
                    secretkryVariable: 'AWS_SECRET_KEY_ID'
                ]]
                ){
                    ansiColor('xterm') {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage ('show') {
            node {
                withCredentials(
                [[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsID: credentialsID,
                    accesskeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretkryVariable: 'AWS_SECRET_KEY_ID'
                ]]
                ){
                    ansiColor('xterm'){
                        sh 'terraform show'
                    }
                }
            }
        }
    }
    currentBuild.result = 'SUCCESS'
}
catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException flowerror) {
    cuurentBuild.result = 'ABORTED'
}
catch (err) {
    current.Build.result = ''FAILURE
    throw err
}
finally {
    if (currentBuild.result == 'SUCCESS') {
        currentBuild.result = 'SUCCESS' 
    }
}
