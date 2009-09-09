import re

class Question(object):
    def __init__(self, ofs, s):
        self.ofs = ofs
        self.title = re.search(r' Title="(.*?)"', s).group(1)
        self.score = re.search(r' Score="(.*?)"', s).group(1)
        self.tags = re.findall(r'&lt;(.*?)&gt;', re.search(r' Tags="(.*?)"', s).group(1))

Users = {}
Questions = {}
Answers = {}
Posts = open("posts.xml")

def readusers():
    f = open("users.xml")
    for s in f:
        m = re.search(r' Id="(-?\d+)"', s)
        if m:
            id = m.group(1)
            m = re.search(r' DisplayName="(.*?)"', s)
            Users[id] = m.group(1) if m else "unknown"
    f.close()

def readposts():
    Posts.seek(0)
    while True:
        ofs = Posts.tell()
        s = Posts.readline()
        if len(s) == 0:
            break
        if s.startswith("  <row"):
            m = re.search(r' Id="(\d+)"', s)
            assert m
            id = m.group(1)
            m = re.search(r' PostTypeId="(\d)"', s)
            assert m
            if m.group(1) == "1":
                print "\r", id,
                Questions[id] = Question(ofs, s)
            else:
                m = re.search(r' ParentId="(\d+)"', s)
                assert m
                qid = m.group(1)
                if qid in Answers:
                    a = Answers[qid]
                else:
                    a = []
                    Answers[qid] = a
                a.append(ofs)
    print

def getpost(ofs):
    Posts.seek(ofs)
    s = Posts.readline()
    s = s.strip()
    s = s[4:len(s)-2]
    m = re.search(r' OwnerUserId="(-?\d+)"', s)
    if m:
        if m.group(1) in Users:
            s += ' OwnerDisplayName="' + Users[m.group(1)] + '"'
    return s

readusers()
readposts()

out = open("unify.xml", "w")
print >>out, """<?xml version="1.0" encoding="utf-8"?>"""
print >>out, "<so>"
ids = sorted(Questions, key = int)
for id in ids:
    print "\r", id,
    q = Questions[id]
    print >>out, """  <question Id="%s" Score="%s" Title="%s">""" % (id, q.score, q.title)
    for t in q.tags:
        print >>out, "    <tag>%s</tag>" % t
    print >>out, """  </question>"""
    qout = open("unify/%s.xml" % id, "w")
    print >>qout, """<?xml version="1.0" encoding="utf-8"?>"""
    print >>qout, "<question", getpost(q.ofs), ">"
    if id in Answers:
        for a in Answers[id]:
            print >>qout, "  <answer", getpost(a), "/>"
    print >>qout, "</question>"
    qout.close()
print
print >>out, "</so>"
out.close()
