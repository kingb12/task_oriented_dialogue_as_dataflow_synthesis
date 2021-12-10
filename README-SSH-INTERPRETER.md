# Working remotely w/ Jupyter & PyCharm
author: kingb12

#### What and Why:
This is a how-to for setting up 1) a remote jupyter notebook and 2) a remote interpreter in PyCharm to work with this 
repository as installed on a remote UCSC server like `citrisdance`. The goal is to be able to make changes in the IDE that
are reflected to a remote installation of the repository, where it can be run successfully. Once complete, the 
experience should be close to as seamless as running locally, with the compute benefits of a remote server like 
`citrisdance`. Presuming zero understanding of `ssh`, ports, as my own understanding is limitted to whats
needed for setting this up.

Aspects of the problem unique to the UCSC SOE setup:
- need to make multiple hops to get to a compute resource with real power
- no root access on the remote machine
- missing commands on remote servers cause failures in standard approaches (e.g. no `ssh-rsa` for `ssh-copy-id`)


#### Useful resources

- on setting up an [SSH Config](linuxserver.io/blog/2016-12-02-perform-multiple-ssh-hops-with-ssh-config) file.
- on setting up [ssh-agent](https://rabexc.org/posts/using-ssh-agent), to not have to repeatedly type your password

### Setting up an SSH config

The outcome of this section will allow you to ssh to a remote host
without needing to type in your password.

My SSH config for getting to `citrisdance`:

```
Host gateway
   Hostname gateway.soe.ucsc.edu
   User bking2
   LocalForward 7676 127.0.0.1:7676

Host citrisdance
    Hostname citrisdance
    User bking2
    LocalForward 7676 127.0.0.1:7676
    ProxyCommand ssh gateway -W %h:%p 
```

Here, gateway is the bastion or jump host for SOE computing, through which connections to citrisdance and other SOE 
servers must go when not on the campus network. The first section is equivalent to:
`ssh bking2@gateway.soe.ucsc.edu -L7676:localhost:7676`

Other than the `User`, the other parameter that needs adjusting is the port for local forwarding (or you can remove if not needed).
Connections to port `7676` on my personal machine will route to port `7676` on the remote machine. It's specified on both
hosts so that port `7676` is used for the connection on both hops. If you don't change `7676` to a port number of your choosing, 
you'll be competing with anyone trying to use it:

```
bind [127.0.0.1]:7676: Address already in use
channel_setup_fwd_listener_tcpip: cannot listen to port: 7676
Could not request local forwarding.
```

Now you can run `ssh citrisdance` or `ssh gateway` and log in, though you will still need to input your password.

### Using an SSH Key to avoid password entry

This is a fairly standard setup, but because the remote hosts don't support `ssh-copy-id`, there's a couple unexpected 
steps:

First, generate a public/private key pair for your machine if you don't have one already:
```bash
ssh-keygen -t rsa -P ""
```
I then accepted the defaults and did not associate the key with a passphrase. You would maybe want a passphrase on a 
shared computer or for extra security, but you might have to enter it instead of a password then.
The public key is saved to the file: `~/.ssh/id_rsa.pub` (don't share the private key or put it on a remote host)

Then, copy the public key to a line in the file `~/.ssh/authorized_keys` **on the remote host**. I ended up doing with 
vim (`cat` the public key on your local computer, copy it and paste it into the remote file with an editor), but there
might be a more clever way to work-around the `ssh-copy-id` failure.

Luckily for SOE computing, the home directory is shared so the key now works on **all remote hosts**

You should now be able to `ssh gateway` or `ssh citrisdance` and end up in a shell with no input steps.

### Running a remote jupyter notebook

Now, running a remote jupyter notebook is as easy as running:
`jupyter notebook --no-browser --port=<YOUR PORT>`

Note the notebook will default to requiring a token (since it doesn't know your port is only being forwarded to a 
secure `ssh` channel). The command will provide a link that includes the token:

```
    To access the notebook, open this file in a browser:
        file:///soe/bking2/.local/share/jupyter/runtime/nbserver-17372-open.html
    Or copy and paste one of these URLs:
        http://localhost:7676/?token=3b326dd3904a267c32a5cffe5dc37add9f198c10c6cbe7fd
     or http://127.0.0.1:7676/?token=3b326dd3904a267c32a5cffe5dc37add9f198c10c6cbe7fd
```

### Pycharm remote interpreter

This can mostly be done by following [these instructions](https://www.jetbrains.com/help/pycharm/configuring-remote-interpreters-via-ssh.html#ssh).
Some notes:
- As of writing this, PyCharm does not support creation of remote virtual environments. You can get around this by logging on to the remote host and creating one yourself, then pointing to it when setting up the remote server (point to the python binary in `venv/bin/python`)
- **SFTP is a critical piece of Pycharm's remote interpreter setup**. when connecting via SSH, your `.bashrc`, `.bash_profile` (and `.zshrc`,etc if you use another shell) will all be loaded. It is important these write nothing to standard out, or SFTP will hang indefinitely and Pycharm won't be able to configure the interpreter.
  - you can debug this ahead of time by trying to use sftp directly. `sftp` will honor your `.ssh/config` (e.g. `sftp citrisdance`).
  - If you want to perform no operations in your `.bashrc`, etc in non-interactive mode, you can just put this at the top of the file: ` [[ "$-" != *i* ]] && return`
- you don't need port forwarding, and you can avoid the port conflict by creating distinct profiles in `.ssh/config` for pycharm:

```
Host gateway-pycharm
   Hostname gateway.soe.ucsc.edu
   User bking2

Host citrisdance-pycharm
    Hostname citrisdance
    User bking2
    ProxyCommand ssh gateway-pycharm -W %h:%p
```
