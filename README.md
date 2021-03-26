# Lazy Parser for BibTex files

This is used for auto-complete/right-click inserting of citations in [ThiefMD](https://thiefmd.com).

## Usage

```vala
public class BibtexTest {
    public static void main () {
        // Set file
        BibTex.Parser parser = new BibTex.Parser ("test.bib");
        // Parse
        parser.parse_file ();

        // Print labels and titles
        foreach (var label in parser.get_labels ()) {
            print ("%s - %s\n", label, parser.get_title (label));
        }
    }
}
```