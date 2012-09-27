Creating a repository and initializing hgreview into it:

  $ hg init a
  $ echo "[extensions]" >> a/.hg/hgrc
  $ echo "hgreview =" >> a/.hg/hgrc
  $ echo "[review]" >> a/.hg/hgrc
  $ echo "server = http://localhost:8080" >> a/.hg/hgrc
  $ echo "username = test@somewhere.test" >> a/.hg/hgrc

Then we do some changes to it, and submit them to a running rietveld instance:

  $ cd a
  $ echo 'test' > test
  $ hg add test
  $ hg review -m 'Adding test'
  Server used http://localhost:8080
  Issue created. URL: http://localhost:8080/* (glob)
  Uploading base file for test
  Uploading current file for test
  $ ISSUENUM=`cat .hg/review_id`

Now prepare another repository:

  $ cd ..
  $ hg init b
  $ echo "[extensions]" >> b/.hg/hgrc
  $ echo "hgreview =" >> b/.hg/hgrc
  $ echo "[review]" >> b/.hg/hgrc
  $ echo "server = http://localhost:8080" >> b/.hg/hgrc
  $ echo "username = test@somewhere.test" >> b/.hg/hgrc

And fetch the issue:

  $ cd b
  $ hg review --fetch -i $ISSUENUM
  Looking after issue http://localhost:8080/* patch (glob)
  applying /tmp/* (glob)

The two repositories should be identical

  $ cd ..
  $ diff -x .hg  -r a b

If we do a commit then the file review_id will disappear:

  $ cd a
  $ hg commit -m 'Commit change'
  $ test -e .hg/review_id || echo OK
  OK
