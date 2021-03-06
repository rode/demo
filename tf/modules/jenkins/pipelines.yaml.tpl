jobs:
  - script: |
      folder('${pipelineOrg}') {
      }
      multibranchPipelineJob('${pipelineOrg}/${pipelineRepo}') {
        triggers {
          periodic(1)
        }
        factory {
          workflowBranchProjectFactory {
            scriptPath('Jenkinsfile')
          }
        }
        branchSources {
          git {
            id('https://www.github.com/${pipelineOrg}/${pipelineRepo}.git')
            remote('https://www.github.com/${pipelineOrg}/${pipelineRepo}.git')
            credentialsId('${credentialsSecretName}')
          }
        }
        orphanedItemStrategy {
          discardOldItems {
            numToKeep(20)
          }
        }
      }

%{~ if sonarqube_host != "" }
unclassified:
  sonarGlobalConfiguration:
    buildWrapperEnabled: false
    installations:
    - name: "SonarQube"
      serverUrl: "https://${sonarqube_host}"
      credentialsId: "${sonarqube_credentials}"
%{~ endif }

jenkins:
  globalNodeProperties:
    - envVars:
        env:
          - key: "HARBOR_HOST"
            value: "${harbor_host}"
          - key: "RODE_NAMESPACE"
            value: "${rode_namespace}"
