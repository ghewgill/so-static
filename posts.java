import java.io.*;
import java.util.regex.*;
import java.util.Date;

import com.jclark.xsl.sax.Driver;

class posts {
    public static void main(String[] args) {
        System.out.println("Transforming to HTML");
        Pattern p = Pattern.compile("Id=\"(\\d+)\"");
        long start = System.currentTimeMillis();
        try {
            File ff = new File("unify.xml");
            long size = ff.length();
            BufferedReader f = new BufferedReader(new FileReader(ff));
            long ofs = 0;
            while (true) {
                String s = f.readLine();
                if (s == null) {
                    break;
                }
                ofs += s.length();
                Matcher m = p.matcher(s);
                if (m.find() /*&& Integer.valueOf(m.group(1)) < 1000*/) {
                    System.out.print("\r" + m.group(1) + " " + (ofs * 100 / size) + "% " + new Date(start + (System.currentTimeMillis() - start) * size / ofs).toLocaleString());
                    StringBuilder fn = new StringBuilder();
                    for (int i = 0; i < m.group(1).length(); i += 3) {
                        if (fn.length() > 0) {
                            new File("static/questions/"+fn).mkdir();
                            fn.append("/");
                        }
                        fn.append(m.group(1).substring(i, i+3 > m.group(1).length() ? m.group(1).length() : i+3));
                    }
                    Driver.main(new String[] {
                        "unify/" + fn + ".xml",
                        "posts.xsl",
                        "static/questions/" + fn + ".html"
                    });
                }
            }
            f.close();
        } catch (IOException x) {
            System.err.println(x);
        }
    }
}
