# data bus

iCentris data bus elements, for the Leo Framework.

## Application Documentation

[Application Documentation is available in the Wiki](../../wiki)

## Developer Setup

You will need:

1. Docker Installed
2. AWS credentials
3. AWS CLI installed
4. Setup your db

### Install Docker

* Install [docker](https://www.docker.com/community-edition)
* Install [docker-compose](https://docs.docker.com/compose/install/)

If you don't know docker, [skim through a few tutorials](https://docker-curriculum.com/), with a goal to understand:

* What is a docker container and how is it different from a VM?
* How do I build a docker image?
* How do I run docker with docker-compose?

### AWS Access Key

If you do not have a user in our AWS dev account, submit a Jira ticket to the IT queue with the subject: Developer AWS Account access, requesting the account, and referencing this project and who is sponsoring your access (your XM).

Once you get an account, login and [create an Access Key](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)

### AWS CLI

It will help (but is not required) to have the AWS CLI.  You can also edit the container to bring your access key in differently (such as with an environment variable).

Currently these are stored in ~/.aws/credentials and mapped into the container.  This is insecure but for now it's what we are doing (-BJG).

On a mac:

```bash
brew install awscli
```

On Linux:

```bash
pip install awscli
```

Afterwards you can configure your access key by running:

```bash
aws configure --region=us-west-2
```

### Setup your DB

We are using a fictional customer `bluesun` for our testing and evaluation, with simulated data.

When you first start a stack (see developing below), the database is empty.  You can populate it by running (but change `{profile}` to match the profile being used, such as `fullstack`):

```bash
docker-compose -f docker/{profile}/docker-compose.yml exec -T db /bin/bash -c '/data/setup-db.sh bluesun'
```

## Developing

* App code is located in `src/`.
* DB files are in `data/` (notably the db's are each in `data/db/{profile}`)
* We use docker, and have a set of profiles depending upon the use case, located in `docker/`.  Each sub-folder is a profile.
* A helper tool exists `./local` to assist in using the different profiles, BUT IS NOT REQUIRED.  You can just run your own docker commands/aliases.

There are three main command-line tools you will employ while working on the leo-bus:

* [npm](https://docs.npmjs.com/getting-started/what-is-npm)
* [aws](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
* [leo-cli](https://github.com/LeoPlatform/cli)

### Developing, Docker and ./local

./local is merely a helper wrapper for docker compose.  You do not have to use it, and where it gets in the way you should just run docker or docker-compose directly.

It uses profiles for docker compose, located in `docker/{profile}` so you can have different setups depending upon what you are doing and / or testing.

For example, if you find you are primarily using the `fullstack` profile, perhaps a simple docker compose alias is in order:

```bash
alias dcf='docker-compose -f docker/fullstack/docker-compose.yml'
```

* Profiles you probably care about:

    * fullstack &mdash; a fullstack local development profile, including database and aws emulator.  good for local development
    * build-test &mdash; do testing during the build phase (by jenkins)
    * build-swarm &mdash; the way we build our container for swarm

* Some common use cases:

```bash
./local build fullstack   # build image as a shared volume container (such as for developing locally)
./local up fullstack -d   # run a shell as the local shared volume container
./local sh fullstack      # get a shell in the (now up) fullstack/leo-bus container
```

Or a common re-build scenario:
```bash
./local build fullstack   # build image as a shared volume container (such as for developing locally)
./local restart fullstack # restart after doing a build
```

If you don't like any of the stock profiles, you can just copy one of the folders to your own username and customize it to match your needs!

Ultimately the `local` script is just a helper for some of the more complex docker commands.  You DO NOT have to use it.  It always prints out what it is doing, so you can copy and adjust to suite your needs.

## Examples

### Basic Development

Use the `fullstack` container, get a shell in it and install initial dependencies for npm:

```bash
./local build fullstack   # build image as a shared volume container (such as for developing locally)
./local up fullstack -d   # run a shell as the local shared volume container
./local sh fullstack      # get a shell in the (now up) fullstack/leo-bus container
npm install             # this last is run within the container
```

### Local Testing

From a container shell (`./local sh fullstack`) run:

```bash
npm install; npm test;
```

### Full CI Testing

Our Continuous Integration runs the container profile `build-test`.  Run the `docker/build-test/run-test.sh` script to emulate  Jenkins' test verification.

# Configuring

Configs are a hot mess, yay lambdas.

Various places to find configurations (some runtime, some bot):

  * `cloudformation/params.js` -- definitions for envs in `bots/**/package.json`
  * `bots/**/package.json`
  * `package.json` -- Globals can go here, but the deploy has to futz with it, so it's ugly
  * `leo_cli_config.json.in` -- template, used to generate leo_cli_config.json file in ./deploy

## Editing Lane/Client Configs

1. From inside the fullstack container, run `python3 edit_config.py -e local|dev|tst|prd -u your.name@icentris.com`.
2. Enter your OneLogin Password when prompted
3. You should receive a OneLogin Protect alert on your phone, accept it
4. Edit the config file
5. Don't forget to commit your changes when done editing


# Deploying

Deploying to dev, tst, and prd *SHOULD* be done through Jenkins. If for some reason you need to deploy code to `dev`
that is not on master, then you can do the following:

Create temporary aws credentials and export them to your local machine.

    ../onelogin-to-aws/run.sh -d

Build container for deployment -- this keeps the files isolated, as the deploy process has to monkey with files.

    ./local build deploy

And run for `dev`:

    ./local run-sh deploy ./deploy dev

* You can do a test push using the `databus-ingress` source base, at `src/apikey-test-environ.js` -- just update the source and change `eventData` and `eventType`

* debugging:

    ./local run-sh deploy /bin/bash

This doesn't work -- it deletes the other bots -- but is useful for faster testing

    BOT=load/trinity/customer_enrollment
    leo-cli publish -d $ENV_SHORT -f $BOT --filter $BOT --force-deploy

# Installing Infrastructure

1. create in AWS gui using cloud formation, per Leo docs:

   https://github.com/LeoPlatform/Leo#step-2-install-the-leo-platform

   name: `databus-leo-{environ}`

   Tags:
     Env: {environ}
     Purpose: Databus Leo Insights

2. setup AWS Roles to include Leo policies as appropriate:

   - search for role: LeoBotPolicy, add it to the policies for `rancher-agent-role`

# Change Detection Testing

### Exigo (MSSQL)

LoadExigoChangeDetection is responsible for reading changes on the sqlserver datasource.  Based on what table changed, an event will be sent to the `exigo-changes` queue containing the table name and its ID:

```
    payload: {
        insert : {
            idlife : {
                Customers : [ 
                    { CustomerID : 2 }
                ],
                Commissions:  [
                    { CommissionRunID : 1 , CustomerID : 2 }
                ],
            }
        },
        update : {},
        delete : {}
    }
```

Domain loaders then subscribe to the `exigo-changes` queue and query the database transforming the data to be placed on the data-bus pipeline.

### Exigo Testing on Leo Development Environment

1) From the commandline, make sure your docker instance is up.

```
./local up fullstack -d
```

2) Next, authenticate your shell

```
../onelogin-to-aws/run.sh -d
```

3) Copy and paste the console output like from the example below:

```
export AWS_SESSION_TOKEN=FQoGZXI...

export AWS_ACCESS_KEY_ID=ASIA...

export AWS_SECRET_ACCESS_KEY=3aV5...

```

4) Point dev db to your local machine
```
./test_exigo_dev stu.murry@icentris.com
```
5) ensure port :1433 is active
```
netstat -tunlp
```

6) Make some changes
```
node /src/utils/test_exigo_dev.js
```

# errors
`AccessDeniedException: Failed to load config from gitlab with error: The ciphertext refers to a customer master key that does not exist, does not exist in this region, or you are not allowed to access.`

- Solution: edit KMS (icedev) instance and add `arn:aws:iam::575159215130:role/databus-leo-dev-bots-ApiRole-1TOAY22JICD2Y`

```
{
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::575159215130:role/EKS-ASG-NodeInstanceRole-1V0ANHMGO9106",
                    "arn:aws:iam::575159215130:role/databus-leo-dev-bots-ApiRole-1TOAY22JICD2Y",
                    "arn:aws:iam::575159215130:role/SSOAdmin",
                    "arn:aws:iam::575159215130:user/automation"
                ]
            },
```

# mysql

To access the RDS databases.  Do the following:

ssh stu.murry@icentris.com@gateway.prd.vibeoffice.com
`stu.murry@icentris.com@ip-10-64-17-35:~$`  mysql_user_refresh.sh --client=stampinup-prd

# databus-ingress queues

The [databus-ingress](https://github.com/iCentris/data-bus-ingress) is a separate API Express Node app that runs in a seperate container.  This handy tool helps load payloads without writing a separate bot.  Data is written to the bus by `POST` http methods.

* POST /data/v1/object/new-users => Will prepend `ingress-proxy-` to the queue name and write a payload to `ingress-proxy-new-users`

## databus-ingress logging

To see event logging, 

https://gitea.prd.vibeoffice.com/icentris/documentation/src/branch/master/VIBE/logging.md 

`kubernetes.labels.app:"databus-ingress" AND kubernetes.labels.env:"prd"`

# GCP
Google cloud platform has an SDK that allows access to resources directly.
You will need to setup a key in order to use this SDK.  When keys are generated, they are
only allowed to be created one time.  You will need to take the contents of this key
and place it into Kubernetes repo on Gitea. 

## Creating a key (via IAM Service Account)
* Log into GCP console
* select `IAM` -> `Service Accounts` from left dropdown menu
* click the `databus-role@{project_id}.iam.gserviceaccount.com` account
* click `EDIT`
* click `+ CREATE KEY`
* Select `JSON` for the key type
* a key will be downloaded to your local harddrive
* select `done`
* go into finder where it downloaded the key file.
* right click -> `edit with vscode`
* copy it.
* run `edit_config.py` and paste the key in the appropriate location in the config file.




