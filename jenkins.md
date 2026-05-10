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

