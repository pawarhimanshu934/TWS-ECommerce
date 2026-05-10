Jenkins Authentication with Git:

Better long-term: Use SSH

👉 This is what most DevOps teams use

Steps:
Generate SSH key on Jenkins server
Add public key to GitHub
Use repo URL like:
git@github.com:pawarhimanshu934/TWS-ECommerce.git

👉 No tokens, no passwords, cleaner setup

withCredentials is old way.

this is the real DevOps way 🔥
Let’s set up SSH authentication between Jenkins and GitHub step by step.

No shortcuts, clean setup.

What we’re doing
Jenkins Server → SSH Key → GitHub → Push Code Securely

👉 No passwords
👉 No tokens
👉 Stable for CI/CD


Step 1: Generate SSH key on Jenkins server, ensure these keys are generated on ~/.ssh x

SSH into your Jenkins machine and run:

ssh-keygen -> give file name - "jenkins"

Press Enter for all prompts (no passphrase for CI/CD).

Fix permissions (VERY IMPORTANT)
chmod 600 ~/.ssh/jenkins
chmod 644 ~/.ssh/jenkins.pub

Step 2: Copy public key
cat ~/.ssh/jenkins.pub

👉 Copy the entire output


🚀 Step 3: Add key to GitHub

Go to your project repo setting -> add keys

Click:

New SSH Key
Paste the key
Save


Step 4: Add key to SSH agent ( Jenkins Server )
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/jenkins

Step 5:
ssh -T git@github.com

Step 6:
✅ Expected success
Hi pawarhimanshu934! You've successfully authenticated





🚀 Step 7: Configure repo to use SSH

In server/server where your project files are present :

git remote set-url origin git@github.com:pawarhimanshu934/TWS-ECommerce.git

Check:

git remote -v

Should show:

git@github.com:... ✅


🚀 Step 8: Add SSH key to Jenkins credentials

In Jenkins UI:

Go to Manage Jenkins → Credentials
Add new credential:
Kind: SSH Username with private key
ID: github-ssh
Username: git
Private Key: Paste contents of ~/.ssh/id_ed25519


🚀 Step 9: Update your Jenkins pipeline

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


🚀 Step 8: Handle first-time host verification (IMPORTANT)

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