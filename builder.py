from subprocess import call
from builder import s3_committer

call('brunch b -o', shell=True)
s3_committer.commit_to_s3()

print 'Task done.'
