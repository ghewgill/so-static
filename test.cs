using System;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;

public class test {
    public static void Main(string[] args) {
        if (false) {
            var doc = new XPathDocument("users.xml");
            var xsl = new XslTransform();
            xsl.Load("users.xsl");
            var nav = doc.CreateNavigator();
            var iter = nav.Select("/users/row");
            while (iter.MoveNext()) {
                string id = iter.Current.GetAttribute("Id", "");
                var writer = new XmlTextWriter(String.Format("static/users/{0}.html", id), null);
                xsl.Transform(iter.Current, null, writer, null);
                writer.Close();
            }
        }
        if (true) {
            var comments = new XPathDocument("comments.xml");
            var nav = comments.CreateNavigator();
        }
    }
}
