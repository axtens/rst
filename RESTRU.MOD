MODULE Restructure;
FROM Strings IMPORT Assign, CompareStr;
FROM InOut IMPORT WriteString, WriteLine, RedirectOutput;
FROM SLICE IMPORT Slice;
FROM XDOS IMPORT ReadFileLine;
FROM Files IMPORT Read, Open, READ, Close;
FROM XString IMPORT UpperCase, RightTrim, Exact;
FROM System IMPORT GetArg, Terminate;
FROM DevIO IMPORT CardErr, WriteErr, NLErr, LineErr;
TYPE
    tString = ARRAY [0..127] OF CHAR;
VAR
    i : INTEGER;
    cLines,
    n : CARDINAL;
    axFilename,
    axString,
    axTemp1,
    axTemp2,
    axTemp3 : tString;
    bDebug,
    bFlag : BOOLEAN;

PROCEDURE Syntax( axNotFound : ARRAY OF CHAR);
BEGIN
    LineErr(" lines processed.");
    WriteErr("Syntax error. Line:");
    CardErr(cLines,3);
    WriteErr(". Keyword [");
    WriteErr( axNotFound);
    LineErr("] not found. Error ignored.")
END Syntax;

PROCEDURE DefineFile();
BEGIN
    Slice( axString, axTemp1);
    WriteString("USE ");
    Assign(axTemp1,axFilename);
    RightTrim( axFilename);
    WriteString(axFilename);
    WriteLine(" ALIAS RST NEW");
    WriteLine("aFileArray := dbstruct()");

END DefineFile;

PROCEDURE Change();
BEGIN
    Slice(axString, axTemp1); (* fieldname *)
    WriteString("n := ASCAN( aFileArray, { |aVal| aVal[1] == [");
    UpperCase(axTemp1);
    WriteString(axTemp1);
    WriteLine("] } )");
    WriteLine("IF n <> 0");
    Slice( axString, axTemp1);
    IF Exact( axTemp1, "name") THEN
        Slice( axString, axTemp1);
        WriteString( " aFileArray[n][1] := [");
        UpperCase( axTemp1);
        WriteString( axTemp1);
        WriteLine("]");
        Slice( axString, axTemp1);
    END;
    IF Exact( axTemp1, "type") THEN
        Slice( axString, axTemp1);
        WriteString( " aFileArray[n][2] := [");
        UpperCase( axTemp1);
        WriteString( axTemp1);
        WriteLine("]");
        Slice( axString, axTemp1);
    END;
    IF Exact( axTemp1, "len") THEN
        Slice( axString, axTemp1);
        WriteString( " aFileArray[n][3] := ");
        WriteString( axTemp1);
        WriteLine("");
        Slice( axString, axTemp1);
    END;
    IF Exact( axTemp1, "dec") THEN
        Slice( axString, axTemp1);
        WriteString( " aFileArray[n][4] := ");
        WriteString( axTemp1);
        WriteLine("");
    END;
    WriteLine("END");
END Change;
PROCEDURE Go();
BEGIN
    WriteLine("COPY TO TEMP");
    WriteString("ERASE ");
    WriteString( axFilename);
    WriteLine(".DBF");
    WriteString("dbcreate( [");
    WriteString(axFilename);
    WriteLine("], aFileArray)");
    WriteString("USE ");
    WriteString( axFilename);
    WriteLine(" NEW");
    WriteLine("APPEND FROM TEMP");
    WriteLine("CLOSE DATABASES");
    WriteLine("ERASE TEMP.DBF")
END Go;
PROCEDURE Code();
BEGIN
    RightTrim( axString);
    WriteLine( axString)
END Code;


BEGIN
    LineErr("RESTRUCTURE v1.0 (c) Copyright Bruce M. Axtens, 1993.");
    GetArg(axTemp1,n);
    IF n=0 THEN
        axTemp2 := 'DEFAULT.RST'
    ELSE
        axTemp2 := axTemp1
    END;

    GetArg(axTemp1,n);
    IF n=0 THEN
        axTemp3 := 'DEFAULT.PRG'
    ELSE
        axTemp3 := axTemp1
    END;

    GetArg( axTemp1, n);
    IF n # 0 THEN
        bDebug := ( CAP(axTemp1[0])='D')
    ELSE
        bDebug := FALSE
    END;

    Open(i,axTemp2,READ);
    IF i = -1 THEN
        WriteErr("Could not open ");
        WriteErr( axTemp2);
        NLErr;
        Terminate(1)
    END;
    RedirectOutput(axTemp3);
    cLines := 0;
    ReadFileLine(i,axString,n);
    bFlag := FALSE;
    WHILE n <> 0 DO
        INC( cLines);
        WriteErr( CHR(13));
        CardErr( cLines,5);
        IF bDebug THEN
            RightTrim(axString);
            WriteString("**RESTRUCTURE: ");
            WriteLine(axString);
        END;
        Slice( axString, axTemp1);
        IF Exact(axTemp1,"res") THEN
            DefineFile()
        ELSE
            IF Exact(axTemp1,"chg") THEN
                Change();
            ELSE
                IF Exact( axTemp1, "go") THEN
                    Go()
                ELSE
                    IF Exact(axTemp1,"code") THEN
                        Code()
                    END
                END
            END;
        END;
        ReadFileLine(i,axString,n);
    END;
    Close(i);
    LineErr(" lines processed.")

END Restructure.






