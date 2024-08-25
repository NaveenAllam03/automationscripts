one way to connect with remote repo

create a repo remotely 


then open local terminal 
clone the remote repo to local using remote repo ssh

use commands to keygen
1. ssh-keygen -t ed25519 -C "your-email-id"
2. publickey and private keys are generated
3. keep the private key with you and place public key in github
4. then go to terminal and do 
      ssh -t git@github.com
5. github will connect
