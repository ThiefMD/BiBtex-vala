namespace BibTex {
    errordomain BiBError {
        FORMATTING_ERROR
    }

    public class Parser : Object {
        private string bibtex_file;
        private Gee.Map<string, Gee.Map<string, string>> entries;
        public Parser (string file = "") {
            bibtex_file = file;
            entries = null;
        }

        public bool set_file (string file) {
            File test = File.new_for_path (file);
            if (test.query_exists ()) {
                bibtex_file = file;
                return true;
            }

            return false;
        }

        public bool parse_file (bool add_entries = false) {
            File to_parse = File.new_for_path (bibtex_file);
            if (bibtex_file == "" || !to_parse.query_exists ()) {
                return false;
            }

            if (entries == null || !add_entries) {
                entries = new Gee.HashMap <string, Gee.Map<string, string>> ();
            }

            Gee.HashMap<string, string> entry = null;
            Gee.HashMap<string, string> strings = new Gee.HashMap<string, string> ();
            DataInputStream? input = null;
            try {
                input = new DataInputStream (to_parse.read ());
                string line;
                string label = "";
                while ((line = input.read_line (null)) != null) {
                    line = line.chomp ().chug ();
                    if (line.has_prefix ("@")) {
                        int curly = throw_if_not_index (line.index_of_char ('{'));
                        string type = line.substring (1, curly - 1).down ().chomp ().chug ();
                        if (type != "string" && type != "preamble" && type != "comment") {
                            entry = new Gee.HashMap<string, string> ();
                            int comma = line.index_of_char (',', curly);
                            if (comma == -1) {
                                curly = 0;
                                while ((line = input.read_line (null)) != null) {
                                    line = line.chomp ().chug ();
                                    if (line != "") {
                                        break;
                                    }
                                }
                                comma = throw_if_not_index (line.index_of_char (',', curly));
                                curly = -1;
                            }
                            label = line.substring (curly + 1, comma - (curly + 1)).chug ().chomp ();
                            while ((line = input.read_line (null)) != null) {
                                line = line.chomp ().chug ();
                                int equality = line.index_of_char ('=');
                                if (equality != -1) {
                                    string key = line.substring (0, equality).chug ().chomp ();
                                    string value = line.substring (equality + 1).chomp ().chug ();
                                    while (value.has_suffix ("}") || value.has_suffix (",") || value.has_suffix ("\"")) {
                                        value = value.substring (0, value.length - 1);
                                    }
                                    while (value.has_prefix ("{") || value.has_prefix ("\"")) {
                                        value = value.substring (1, value.length - 1);
                                    }
                                    entry.set (key, value);
                                }
                                if (line.has_suffix ("}")) {
                                    break;
                                }
                            }
                            if (!entry.is_empty && label != "") {
                                entry.set ("type", type);
                                entries.set (label, entry);
                            }
                            entry = null;
                        } else if (type == "string") {
                            int equality = line.index_of_char ('=', curly);
                            if (equality == -1) {
                                curly = 0;
                                while ((line = input.read_line (null)) != null) {
                                    line = line.chomp ().chug ();
                                    if (line != "") {
                                        break;
                                    }
                                }
                                equality = throw_if_not_index (line.index_of_char ('=', curly));
                                curly = -1;
                            }
                            label = line.substring (curly + 1, equality - (curly + 1)).chug ().chomp ();
                            int close_brace = line.last_index_of_char ('}');
                            string value = line.substring (equality + 1, ((close_brace != -1) ? close_brace : line.length) - (equality + 1)).chug ().chomp ();
                            strings.set (label, value);
                        }
                    }
                }

                if (entry != null && !entry.is_empty) {
                    entries.set (label, entry);
                }
            } catch (Error e) {
                warning ("Could not parse %s: %s\n", to_parse.get_path (), e.message);
            } finally {
                if (input != null) {
                    try {
                        input.close ();
                    } catch (Error e) {
                        warning ("Could not close bibtex parse stream: %s", e.message);
                    }
                }
            }

            return true;
        }

        public Gee.Set<string> get_labels () {
            if (entries != null && !entries.is_empty) {
                return entries.keys;
            } else {
                return new Gee.HashSet<string> ();
            }
        }

        public string get_title (string label) {
            string possible_title = "";

            if (entries != null && entries.has_key (label)) {
                var entry = entries.get (label);
                if (entry.has_key ("title")) {
                    possible_title = entry.get ("title");
                }
            }

            return possible_title;
        }

        private int throw_if_not_index (int value) throws Error {
            if (value == -1) {
                throw new BiBError.FORMATTING_ERROR ("Entry is not a valid formatted BiBTex Entry");
            }

            return value;
        }
    }
}