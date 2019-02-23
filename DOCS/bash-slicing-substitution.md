#### Bash Builtin slicing, substitution, deletion

	''f="path1/path2/file.ext"''

**Variable length** `len="${#f}" # len=20 in this case`

**Variable slicing:** `${<var>:<start>} or ${<var>:<start>:<length>}`

    slice1="${f:6}" # = "path2/file.ext"
    slice2="${f:6:5}" # = "path2"
    slice3="${f: -8}" # = "file.ext"(Note: space before "-")
    pos=6; len=5
    slice4="${f:${pos}:${len}}" # = "path2"

**String substitution**

    single_subst="${f/path?/x}"   # = "x/path2/file.ext"
    global_subst="${f//path?/x}"  # = "x/x/file.ext"

**String splitting**

    readonly DIR_SEP="/"
    array=(${f//${DIR_SEP}/ })
    second_dir="${array[1]}"     # = path2

**Deletion at beginning/end**

    end="${f#*.}"  # = "ext"
    filename="${f##*/}"  # = "file.ext"
    dirname="${f%/*}"    # = "path1/path2"
    root="${f%%/*}"      # = "path1"

