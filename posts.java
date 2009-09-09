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
                    Driver.main(new String[] {
                        "unify/" + m.group(1) + ".xml",
                        "posts.xsl",
                        "static/questions/" + m.group(1) + ".html"
                    });
                }
            }
            f.close();
        } catch (IOException x) {
            System.err.println(x);
        }
    }
}
