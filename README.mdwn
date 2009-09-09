Stack Overflow static dump tools
================================

Extract the full contents of the data dump into this directory.
Run:

    mkdir -p static/users
    mkdir -p static/questions
    mkdir unify
    ./xt users.xml users.xsl
    python unify.py
    ./posts.sh
