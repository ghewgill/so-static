import glob
import hashlib
import os
import select
import sys
import urllib.request

def fetch_retry(url):
    tries = 0
    while True:
        try:
            return urllib.request.urlopen(url)
        except urllib.error.URLError as x:
            tries += 1
            if tries < 3:
                print("  retry: {}".format(x))
            else:
                raise

def doit(request, response):
    for url in request:
        url = url.strip()
        hash = hashlib.sha1(url.encode("utf-8")).hexdigest()
        if not glob.glob(os.path.join(destdir, hash + "*")):
            try:
                r = fetch_retry(url)
                if r.getcode() == 200:
                    ct = r.getheader("Content-Type")
                    if ';' in ct:
                        # handle bizarre Content-Type: image/png; charset=UTF-8
                        ct = ct[:ct.index(';')]
                    ext = {
                        "image/gif":  ".gif",
                        "image/jpeg": ".jpg",
                        "image/png":  ".png",
                    }[ct]
                    with open(os.path.join(destdir, hash + ext), "wb") as f:
                        f.write(r.read())
                else:
                    with open(os.path.join(destdir, hash), "w") as f:
                        print(url, file=f)
                        print(r.getcode(), file=f)
            except Exception as x:
                print("{0} ({1})".format(x, url))
                with open(os.path.join(destdir, hash), "w") as f:
                    print(url, file=f)
                    print(x, file=f)
        response.write(chr(0))
        response.flush()

destdir = sys.argv[1]
try:
    os.mkdir(destdir)
except OSError:
    pass

workers = []
for i in range(10):
    request_r, request_w = os.pipe()
    response_r, response_w = os.pipe()
    child = os.fork()
    if child == 0:
        os.close(request_w)
        os.close(response_r)
        doit(os.fdopen(request_r, "r"), os.fdopen(response_w, "w"))
        sys.exit(0)
    else:
        os.close(request_r)
        os.close(response_w)
        workers.append((os.fdopen(request_w, "w"), os.fdopen(response_r, "r")))
names = [x.strip() for x in sys.stdin]
inuse = [False] * len(workers)
while names or any(inuse):
    for i in range(len(inuse)):
        if not inuse[i] and names:
            name = names.pop()
            print("to worker:", name)
            workers[i][0].write(name + "\n")
            workers[i][0].flush()
            inuse[i] = True
    r, w, e = select.select([x[1] for x in workers], [], [], 0)
    for s in r:
        x = s.read(1)
        assert len(x) == 1
        i = [x for x in enumerate(workers) if x[1][1] is s][0][0]
        inuse[i] = False
for w in workers:
    w[0].close()
