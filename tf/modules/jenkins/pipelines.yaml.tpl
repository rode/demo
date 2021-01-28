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
            scriptPath('app/Jenkinsfile')
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
unclassified:
  sonarGlobalConfiguration:
    buildWrapperEnabled: false
    installations:
    - name: "SonarQube"
      serverUrl: "http://sonarqube-sonarqube"
      triggers:
        skipScmCause: false
        skipUpstreamCause: false
