# JENKINS CONFIGURATION FOR THIS PROJECT

## Initial Setup

1. Install Jenkins and Docker on Jenkins Server → Switch to Jenkins user
2. Install Suggest plugin on Jenkins Console
3. Go to Settings → Credentials → Global Credentials → "Username with Password" → Add Docker username and token
   - Get username and token from DockerHub
4. Go to Settings → Credentials → Global Credentials → "SSH Username with Private Key" → Add GitHub ID (github-ssh) with username (git)
   - Enter the private key you generated on Jenkins Server
5. Go to Settings → System → Add Shared Library
   - Name: `SharedLib`
   - Default version: `main` (branch)
   - Retrieval Method: Modern SCM → give Git URL of your shared library on GitHub
6. Install Stage View Plugin
7. Generate SSH keys on Jenkins Server: `ssh-keygen` (ensure keys are in `~/.ssh`)

---

## Jenkins Authentication with Git

### Why SSH?

This is the real DevOps way 🔥

Better long-term: Use SSH. This is what most DevOps teams use.

**Benefits:**
- ✅ No passwords
- ✅ No tokens
- ✅ Stable for CI/CD

**What we're doing:**
```
Jenkins Server → SSH Key → GitHub → Push Code Securely
```

---

## Step-by-Step SSH Setup Between Jenkins and GitHub

### Step 1: Generate SSH Key on Jenkins Server

Ensure these keys are generated on `~/.ssh`

SSH into your Jenkins machine and run:

```bash
ssh-keygen
# Give file name: jenkins
```

### Step 2: Copy Public Key

```bash
cat ~/.ssh/jenkins.pub
```

### Step 3: Add Key to GitHub

Go to your project repo settings → Deploy Keys and paste the public key content.

### Step 4: Add Key to SSH Agent (Jenkins Server)

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/jenkins
```

### Step 5: Test SSH Connection

```bash
ssh -T git@github.com
```

**Expected success:**
```
Hi pawarhimanshu934! You've successfully authenticated
```

### Step 6: Configure Repository to Use SSH

In the server where your project files are present:

```bash
git remote set-url origin git@github.com:pawarhimanshu934/TWS-ECommerce.git
```

Verify the configuration:

```bash
git remote -v
```

Should show:
```
git@github.com:... ✅
```

### Step 7: Add SSH Private Key to Jenkins Credentials

In Jenkins UI:

1. Go to Manage Jenkins → Credentials
2. Add new credential:
   - **Kind:** SSH Username with private key
   - **ID:** `github-ssh`
   - **Username:** `git`
   - **Private Key:** Paste contents of `~/.ssh/jenkins`

### Step 8: Update Your Jenkins Pipeline

Replace `gitUsernamePassword` with:

```groovy
withCredentials([sshUserPrivateKey(
    credentialsId: 'github-ssh',
    keyFileVariable: 'SSH_KEY'
)]) {
    sh """
        eval \$(ssh-agent -s)
        ssh-add \$SSH_KEY

        git config user.name "Jenkins"
        git config user.email "jenkins@example.com"
    """
}
```

### Step 9: Handle First-Time Host Verification (IMPORTANT)

First time GitHub connects, it may ask:

```
Are you sure you want to continue connecting (yes/no)?
```

Fix it by running once on server:

```bash
ssh-keyscan github.com >> ~/.ssh/known_hosts
```

---

## Final Architecture

```
Jenkins
  ↓ (SSH key)
GitHub Repo
  ↓
Push manifests
  ↓
(Next: ArgoCD will auto-deploy)
```
