USE test ALIAS RST NEW
aFileArray := dbstruct()
? "changing NAME to len 100"
n := ASCAN( aFileArray, { |aVal| aVal[1] == [NAME] } )
IF n <> 0
 aFileArray[n][3] := 100

END
n := ASCAN( aFileArray, { |aVal| aVal[1] == [AGE] } )
IF n <> 0
 aFileArray[n][3] := 4

END
n := ASCAN( aFileArray, { |aVal| aVal[1] == [HEIGHT] } )
IF n <> 0
 aFileArray[n][3] := 3
 aFileArray[n][4] := 1

END
COPY TO TEMP
ERASE test.DBF
dbcreate( [test], aFileArray)
USE test NEW
APPEND FROM TEMP
CLOSE DATABASES
ERASE TEMP.DBF
