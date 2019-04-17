
def get_ssh_hostkeys(address, port):
    """ get host keys and fingerprints from a SSH server """
    keyscan_command = ['ssh-keyscan', '-p', port, address]
    process = subprocess.run(keyscan_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    try:
        process.check_returncode()
    except Exception as err:
        print('STDERR:', err.stderr.decode('utf-8'))
        print('STDOUT:', err.stdout.decode('utf-8'))
        raise
    hostkeys = process.stdout.decode('utf-8')

    with open('.hostkeys.tmp', 'w+') as hostkeys_tmp:
        hostkeys_tmp.write(hostkeys)

    fingerprint_command = ['ssh-keygen', '-lf', '.hostkeys.tmp']
    process = subprocess.run(fingerprint_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    try:
        process.check_returncode()
    except Exception as err:
        print('STDERR:', err.stderr.decode('utf-8'))
        print('STDOUT:', err.stdout.decode('utf-8'))
        raise
    fingerprints = process.stdout.decode('utf-8')

    os.remove('.hostkeys.tmp')
    return hostkeys, fingerprints

def write_known_hosts(hostkeys, fingerprints):
    """ show fingerprints for SSH public keys, prompt to add them to ~/.ssh/known_hosts """
    print('[srv01] INFO: the server key fingerprints are:')
    print(fingerprints)
    write_known_hosts = ''
    while write_known_hosts not in ['y', 'Y', 'n', 'N']:
        write_known_hosts = input('Add the server keys to ~/.ssh/known_hosts? [Y/n] ')
        if write_known_hosts in ['N', 'n']:
            print('[srv01] ERROR: Authentication aborted')
            exit(1)
        elif write_known_hosts in ['Y', 'y']:
            with open(os.getenv('HOME') + '/.ssh/known_hosts', 'a+') as known_hosts:
                known_hosts.write(hostkeys)

def test_ssh_user(address, port, user, password):
    """ check if password SSH authentication succeeds """
    print('[srv01] INFO: Trying to connect as {} on {} port {} ...'.format(user, address, port))
    ssh_command = ['sshpass', '-p', password, 'ssh', '-p', str(port), user + '@' + address, 'echo', 'hello']
    process = subprocess.run(ssh_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    try:
        process.check_returncode()
    except Exception as err:
        print('[srv01] ERROR: SSH connection failed. Bad username or password?')
        print('[srv01] ERROR: SSH:', err.stderr.decode('utf-8'))
        exit(1)
    print('[srv01] INFO: OK: SSH connection to {}@{} port {} succeeded.'.format(user, address, port))