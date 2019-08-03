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
