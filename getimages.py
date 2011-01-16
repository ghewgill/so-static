import glob
import hashlib
import html.parser
import os
import re
import subprocess
import shutil
import sys

ContentType = {
    ".gif": "image/gif",
    ".jpg": "image/jpeg",
    ".png": "image/png",
}

class Opf:
    def __init__(self, fn):
        with open(fn, encoding="utf-8") as f:
            self.lines = f.readlines()
    def htmlfiles(self):
        return (m.group(1) for m in (re.search(r'<item.*href="(.*?)".*media-type="text/html"/>', x) for x in self.lines) if m is not None)
    def add_images(self, images):
        names = set()
        for url in images:
            fns = glob.glob(os.path.join("static", "images", hashlib.sha1(url.encode("utf-8")).hexdigest() + ".*"))
            if fns:
                assert fns[0][-4] == "."
                names.add(fns[0])
        i = self.lines.index("</manifest>\n")
        self.lines[i:i] = ["""<item id="{0}" href="{1}" media-type="{2}"/>\n""".format(os.path.basename(x)[:-4], x, ContentType[x[-4:]]) for x in names]
    def write(self, fn):
        with open(fn, "w", encoding="utf-8") as f:
            f.write("".join(self.lines))

def read_files(fns):
    r = []
    for fn in fns:
        with open(fn, encoding="iso-8859-1") as f:
            r.append((fn, f.read()))
    return r

class ImageTagFinder(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()
        self.images = []
    def handle_starttag(self, tag, attrs):
        if tag == "img":
            i = [x[0] for x in attrs].index("src")
            src = attrs[i][1]
            if re.match(r"https?:", src):
                self.images.append(src)

def get_image_links(files):
    fns = []
    urls = []
    for fn, data in files:
        try:
            p = ImageTagFinder()
            p.feed(data)
            if p.images:
                fns.append((fn, data))
                urls.extend(p.images)
        except html.parser.HTMLParseError as x:
            print("{0} ({1})".format(x, fn))
    return fns, urls

class ImageRewriter(html.parser.HTMLParser):
    def __init__(self, htmlfn):
        super().__init__()
        self.htmlfn = htmlfn
        self.output = ""
    def handle_starttag(self, tag, attrs):
        if tag == "img":
            i = [x[0] for x in attrs].index("src")
            src = attrs[i][1]
            hash = hashlib.sha1(src.encode("utf-8")).hexdigest()
            fns = glob.glob(os.path.join("static", "images", hash + ".*"))
            if fns:
                attrs[i] = (attrs[i][0], os.path.join(*([".."] * (self.htmlfn.count("/") - 1) + ["images", os.path.basename(fns[0])])))
            self.output += "<{0}{1}>".format(tag, "".join(' {0}="{1}"'.format(*x) for x in attrs))
        else:
            self.output += self.get_starttag_text()
    def handle_endtag(self, tag):
        self.output += "</{}>".format(tag)
    def handle_data(self, data):
        self.output += data
    def handle_charref(self, name):
        self.output += "&#{};".format(name)
    def handle_entityref(self, name):
        self.output += "&{};".format(name)

def rewrite_files(files):
    for fn, data in files:
        p = ImageRewriter(fn)
        p.feed(data)
        with open(fn, "w", encoding="utf-8") as f:
            f.write(p.output)

opf = Opf(sys.argv[1])
files = read_files(opf.htmlfiles())
htmls, images = get_image_links(files)
p = subprocess.Popen([sys.executable, "fetchimages.py", "static/images"], stdin=subprocess.PIPE)
p.communicate("".join("{}\n".format(x) for x in images).encode("utf-8"))
rewrite_files(htmls)
#opf.add_images(images)
opf.write(sys.argv[1])
