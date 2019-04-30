import os
import time
#import git
import subprocess
from datetime import datetime
from sqs_listener import SqsListener

AWS_REGION = os.getenv('AWS_REGION', "")
SQS_QUEUE_NAME = os.getenv('SQS_QUEUE_NAME', "")
GIT_REPO_URL = os.getenv('GIT_REPO_URL', "")
GIT_REPO_DIR = os.getenv('GIT_REPO_DIR', "")
GIT_PULL_INTERVAL = os.getenv('GIT_PULL_INTERVAL', "")


def git_config():
    output = subprocess.check_output(
        ["git", "config", "--global", "credential.helper",
         "aws codecommit credential-helper $@"])
    print("[%s] %s" % (datetime.now().isoformat(),
                       output.decode('utf-8').strip('\n')))
    output = subprocess.check_output(
        ["git", "config", "--global", "credential.UseHttpPath", "true"])
    print("[%s] %s" % (datetime.now().isoformat(),
                       output.decode('utf-8').strip('\n')))


def git_clone(git_repo_dir, git_repo_url):
    output = subprocess.check_output(["git", "clone", git_repo_url, git_repo_dir])
    print("[%s] %s" % (datetime.now().isoformat(),
                       output.decode('utf-8').strip('\n')))


def git_pull(git_repo_dir):
    print("[%s] STARTING GIT PULL" % datetime.now().isoformat())
    #g = git.cmd.Git(git_repo_dir)
    #g.pull()
    old_cwd = os.getcwd()
    os.chdir(git_repo_dir)
    output = subprocess.check_output(["git", "pull"])
    print("[%s] %s" % (datetime.now().isoformat(),
                       output.decode('utf-8').strip('\n')))
    os.chdir(old_cwd)


class MyListener(SqsListener):
    def handle_message(self, body, attributes, messages_attributes):
        if body:
            print("[%s] %s" % (datetime.now().isoformat(), body))
            git_pull(GIT_REPO_DIR)
            print("[%s] GIT PULL COMPLETE" % datetime.now().isoformat())


if not os.path.exists("%s/.git" % GIT_REPO_DIR):
    git_clone(GIT_REPO_DIR, GIT_REPO_URL)

body = {}
listener = MyListener(SQS_QUEUE_NAME,
                      error_queue=SQS_QUEUE_NAME,
                      region_name=AWS_REGION)
while True:
    print("[%s] WAITING FOR NEXT SQS MESSAGE" % datetime.now().isoformat())
    time.sleep(int(GIT_PULL_INTERVAL))
    stream = listener.listen()
