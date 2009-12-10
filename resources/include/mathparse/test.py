from parser import parser
parse = parser.parse

tests = (
    ("1", "cc(1.000000, 0.0)"),
    ("z", "z"),
    ("1/z", "(cc(1.000000, 0.0)) / (z)"),
    ("z^2", "pow(z, cc(2.000000, 0.0))"),
)

def main():
    failures = {}
    errors = {}

    for i, o in tests:
        try:
            p = parse(i)
        except Exception, e:
            errors[i] = e
            print "E",
        if p == o:
            print ".",
        else:
            failures[i] = (o, p)
            print "F",
    print
    print

    for i in errors:
        print "Error parsing `%s`: (%s) %s" % (i, type(errors[i]).__name__, str(errors[i]))

    for i in failures:
        print "Failure parsing `%s`: wanted `%s`, got `%s`" % (i, failures[i][0], failures[i][1])

if __name__ == "__main__":
    main()
