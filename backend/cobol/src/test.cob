       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST.
       AUTHOR. Burlacu Vasile
       DATE-WRITTEN. 7 Oct 2025

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Num1 PIC S9(12)V99 VALUE 1271.74.
       01  Num2 PIC S9(12)V99 VALUE  728.50.
       01  ResNum PIC S9(12)V99.
       01  ResEdited PIC -Z(11)9.99.
       01  ResStr PIC X(16).

       PROCEDURE DIVISION.
      *    DISPLAY "[COBOL] Initial values: Num1=" Num1 " Num2=" Num2

           ADD Num1 TO Num2 GIVING ResNum
      *    DISPLAY "[COBOL] After addition: ResNum=" ResNum

           MOVE ResNum TO ResEdited
      *    DISPLAY "[COBOL] After formatting: ResEdited=" ResEdited

           STRING ResEdited DELIMITED BY SIZE INTO ResStr
      *    DISPLAY "[COBOL] After moving to string: ResStr=" ResStr

           CALL "testPrintDouble" USING ResStr
      *    DISPLAY "[COBOL] Finished execution."
           STOP RUN RETURNING 0.
