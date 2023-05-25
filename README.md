# README

## usage:

### step 1
```bash
$ bash ./deploy/onekey_new_user.sh
```

### step 2
```bash
# change new_user to your new user name
$ su - ${new_user}

# execute the following command
$ bash zsh_download.sh

# exit and login again
# change new_user to your new user name
$ exit
$ su - ${new_user}

# copy the private key and keep it
$ cat ~/.ssh/id_rsa
```
