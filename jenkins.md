#JENKINS CONFIGURATION FOR THIS PROJECT

1) Install Jenkins and docker on Jenkins Server --> Switch to Jenkins user
2) Install Suggest plugin on Jenkins Console.
3) Go to Setting -> Credentials -> Global Credentails -> "Username with Password" -> Add Docker username and token via .
   You can get username and token from DockerHub.
4) Go to Setting -> Crendentials -> Global Credentails -> "SSH Username with Private key" -> Add github id(github-ssh) and username (git)
   Enter the private key you generated on Jenkins Server.
5) Go to Setting -> System -> Add Shared Library 
   Name : SharedLib
   Default version : main ( branch )
   Retrival Method : Modern SCM -> give Git URL of your shared libraray on github
6) Install Stage View Plugin.


7) Go to ~/.ssh on Jenkins Server and Generate SSH keys using "ssh-keygen"

8) Jenkins Authentication with Git: This is used when you're pushing code to GitHub from Jenkins Server

Better long-term: Use SSH, This is what most DevOps teams use

This is the real DevOps way 🔥
Let’s set up SSH authentication between Jenkins and GitHub step by step.


What we’re doing
Jenkins Server → SSH Key → GitHub → Push Code Securely

👉 No passwords
👉 No tokens
👉 Stable for CI/CD

🚀 Step 1: Generate SSH key on Jenkins server, ensure these keys are generated on ~/.ssh 

        SSH into your Jenkins machine and run:

        ssh-keygen -> give file name - "jenkins"

🚀 Step 2: Copy public key
        
        cat ~/.ssh/jenkins.pub


🚀 Step 3: Add key to GitHub

        Go to your project repo setting -> Deploy Keys


🚀 Step 4: Add key to SSH agent ( Jenkins Server )
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/jenkins

🚀 Step 5:
        ssh -T git@github.com

        ✅ Expected success
        Hi pawarhimanshu934! You've successfully authenticated

🚀 Step 6: Configure repo to use SSH

        In server/server where your project files are present :
        git remote set-url origin git@github.com:pawarhimanshu934/TWS-ECommerce.git

        Check:
        git remote -v

        Should show:
        git@github.com:... ✅

🚀 Step 7: Add SSH Private key to Jenkins credentials

        In Jenkins UI:

        Go to Manage Jenkins → Credentials
        Add new credential:
        Kind: SSH Username with private key
        ID: github-ssh
        Username: git
        Private Key: Paste contents of ~/.ssh/jenkins


🚀 Step 8: Update your Jenkins pipeline

        Replace gitUsernamePassword with:

withCredentials([sshUserPrivateKey(
    credentialsId: 'github-ssh',
    keyFileVariable: 'SSH_KEY'
)]) {

    sh """
    eval \$(ssh-agent -s)
    ssh-add \$SSH_KEY

    git config user.name "Jenkins"
    git config user.email "jenkins@example.com"


🚀 Step 9: Handle first-time host verification (IMPORTANT)

First time GitHub connects, it may ask:

Are you sure you want to continue connecting (yes/no)?

👉 Fix it by running once on server:

ssh-keyscan github.com >> ~/.ssh/known_hosts



Final architecture
Jenkins
  ↓ (SSH key)
GitHub Repo
  ↓
Push manifests
  ↓
(Next: ArgoCD will auto-deploy)