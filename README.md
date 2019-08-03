# rst
An xBase DBF resturcturer written in Fitted Software Tools Modula-2, generating Clipper 5.2 code

I was working for a construction company. They had many DBF files that they were wanting to restructure. RST was one of the ways I thought of to automate the procedure.

RST uses RESTRU.EXE (written in Modula-2) to parse a job description in an file with an .RST extension. RESTRU.EXE, from the description, generates a Clipper 5.2 PRG file for subsequent compilation and execution.

For example, DEFAULT.RST
```
res thing
chg fldname name fld type c len 20
go
code ? "hello world"
```
RESTRU turns that into
```
USE thing ALIAS RST NEW
aFileArray := dbstruct()
n := ASCAN( aFileArray, { |aVal| aVal[1] == [FLDNAME] } )
IF n <> 0
 aFileArray[n][1] := [FLD]
 aFileArray[n][2] := [C]
 aFileArray[n][3] := 20

END
COPY TO TEMP
ERASE thing.DBF
dbcreate( [thing], aFileArray)
USE thing NEW
APPEND FROM TEMP
CLOSE DATABASES
ERASE TEMP.DBF
? "hello world"
```

See the [xlb](https://github.com/axtens/xlb) project for required non-FST libraries.

Building and/or converting to another Modula-2 is left as a task for the reader and/or the author should he find the time.

Other Modula-2 compilers: [M2F](http://floppsie.comp.glam.ac.uk/Glamorgan/gaius/web/m2fabout.html), [GNU Modula-2](https://www.nongnu.org/gm2/download.html), [XDS](https://github.com/excelsior-oss/xds) and [ADW](https://www.modula2.org/adwm2/).

Other good Modula-2 information can be found at [Peter Moylan](http://www.pmoylan.org/pages/m2/Modula2.html)'s site.
