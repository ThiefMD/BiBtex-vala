public class BibtexTest {
    public static void main () {
        BibTex.Parser parser = new BibTex.Parser ("test.bib");
        parser.parse_file ();

        foreach (var label in parser.get_labels ()) {
            print ("%s - %s\n", label, parser.get_title (label));
        }
    }
}