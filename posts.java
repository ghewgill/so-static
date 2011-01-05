import java.io.*;
import java.util.regex.*;

import com.jclark.xsl.sax.Driver;

class posts {
    public static void main(String[] args) {
        Pattern p = Pattern.compile("Id=\"(\\d+)\"");
        try {
            BufferedReader f = new BufferedReader(new FileReader("unify.xml"));
            while (true) {
                String s = f.readLine();
                if (s == null) {
                    break;
                }
                Matcher m = p.matcher(s);
                if (m.find() /*&& Integer.valueOf(m.group(1)) < 1000*/) {
                    System.out.println(m.group(1));
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
