import subprocess
from subprocess import call, PIPE
import os
import sys
import getopt
import boto3
from cryptography.fernet import Fernet
import json
from pathlib import PosixPath
import tempfile


def communicate(arr):
    print(' '.join(arr))
    with subprocess.Popen(arr, stdin=PIPE, stdout=PIPE, stderr=PIPE) as process:
        stdout, stderr = process.communicate('0\n'.encode())
        print(stderr)
        if stderr:
            print('Error occured.  Do you have the right icentris email address?')
            sys.exit(1)
        return stdout


def paths(env):
    path = PosixPath('/app/leo-bus/src/configs')
    return {'dek_path': path / env / 'dek.enc',
            'config_path': path / env / 'config.enc',
            'path': path / env}


def _create_dek():
    return Fernet.generate_key()


def _get_key_id(env):
    if env in ['tst', 'prd']:
        return 'alias/ice-prd'
    elif env in ['local', 'dev']:
        return 'alias/ice-dev'


def _write_dek(client, env, plaintext):
    response = client.encrypt(KeyId=_get_key_id(env), Plaintext=plaintext)
    with paths(env)['dek_path'].open(mode='wb') as f:
        f.write(response['CiphertextBlob'])


def _read_dek(client, env):
    path = paths(env)['dek_path']
    if path.is_file():
        with path.open(mode='rb') as f:
            ciphertext = f.read()
        dek = client.decrypt(KeyId=_get_key_id(env), CiphertextBlob=ciphertext)
        return dek['Plaintext']
    return None


def _write_config(env, dek, text):
    f = Fernet(dek)
    encrypted = f.encrypt(text.encode('utf-8'))

    with paths(env)['config_path'].open(mode='wb',) as f:
        f.write(encrypted)


def _read_config(env, dek):
    path = paths(env)['config_path']
    if path.is_file():
        with path.open(mode='rb') as f:
            contents = f.read()
            f = Fernet(dek)
            config = f.decrypt(contents)
            return json.loads(config)
    else:
        return {'sensitive': {'bus': {'secrets': {'gcp': ''}}}}


def _run_vim(config):
    editor = os.environ.get('EDITOR', 'vim')
    with tempfile.NamedTemporaryFile(suffix=".json") as tf:
        tf.write(config.encode('utf-8'))
        tf.flush()
        call([editor, tf.name])

        # do the parsing with `tf` using regular File operations.
        # for instance:
        tf.seek(0)
        new_config = tf.read().decode('utf-8')

    try:
        json.loads(new_config)
        confirm = input('Save new file? y/n')

        if (confirm == 'y' or confirm == 'yes'):
            return new_config
        else:
            return
    except ValueError:
        edit = input('Invalid json. (e)dit or (c)ancel?')

        if (edit == 'edit' or edit == 'e'):
            return _run_vim(new_config)
        else:
            return


def edit(env, secret=None):
    client = boto3.client('kms', region_name='us-west-2')
    # Fetch decrypted config file
    dek = _read_dek(client, env)

    config = _read_config(env, dek)
    if secret:
        config['sensitive']['bus']['secrets']['gcp'] = secret

    config = json.dumps(config, sort_keys=True, indent=2)

    # Edit config in vim
    new_config = _run_vim(config)

    if not new_config:
        return

    # Create new dek
    new_dek = _create_dek()

    # Write encrypted key and file
    paths(env)['path'].mkdir(parents=True, exist_ok=True)
    _write_config(env, new_dek, new_config)
    _write_dek(client, env, new_dek)

    print(
        "File successfully edited and saved. Don't forget to commit your changes")


if __name__ == "__main__":

    """
    usage: python3 edit_config.py -u user@icentris.com -e dev

    To generate a new key and place it into the config file:
    python3 edit_config.py -u user@icentris.com -e dev -g secret

    """
    opts, args = getopt.getopt(sys.argv[1:], "e:u:g:")
    config = {
        "client_id": "e0910ab3a590608d52b52ea155de520d3f9664c024691300073e82d60568ef7d",
        "client_secret": "ddaf76ae5185d51250d8dc8bf3d3ca90785754731298eb31c754928bee380fc5",
        "app_id": "840572",
        "subdomain": "icentris",
        "duration": 3600,
        "aws_region": "us-west-2"
    }
    secret = None
    for opt, arg in opts:
        if opt in ('-e'):
            config['env'] = arg
            if (arg == 'dev'):
                print('setting dev environment')
                config['app_id'] = "840572"
            elif (arg == 'local'):
                print('setting local environment')
                config['app_id'] = "840572"
            elif (arg == 'prd'):
                print('setting prd environment')
                config['app_id'] = "844759"
            elif (arg == 'tst'):
                print('setting tst environment')
                config['app_id'] = "844759"
            else:
                print(
                    f'Unknown environment {arg}. -e (expected local, dev, tst or prd)')
                sys.exit(1)
        elif opt in ('-u'):
            config['username'] = arg
        # Disabled until we correct generate code. The following bash command will generate a valid key:
        # dd if=/dev/urandom bs=32 count=1 2>/dev/null | openssl base64
        #
        # elif opt in ('-g'):
        #     print('********* Newly Generated Secrets was updated *********\n')
        #     secret = _create_dek().decode()
        #     print(
        #         """!!! Don't forget to update gcp secrets by adding a new version to `vibe-cdc` !!!\n""")

    lines = communicate([
        'onelogin-aws-assume-role',
        '-i', config['client_id'],
        '-s', config['client_secret'],
        '-a', config['app_id'],
        '-u', config['username'],
        '-d', config['subdomain'],
        '-z', str(config['duration']),
        '--aws-region', config['aws_region'],
    ]).splitlines()

    decodedLines = map(lambda s: s.decode("utf-8"), lines)

    for i in filter(lambda s: s.startswith('export'), decodedLines):
        print(i)
        kv = i.split(' ')[1]
        start_pos = kv.index('=')
        k = kv[0:start_pos]
        v = kv[start_pos+1:]
        os.environ[k] = v

    edit(config['env'], secret)
