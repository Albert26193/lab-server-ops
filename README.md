# README

## usage:

### step 1

```bash
$ chmod -R 755 .
$ cd ./deploy
# because use the relative path, so you must execute the following command in the deploy directory
$ sudo bash ./onekey_new_user.sh
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
