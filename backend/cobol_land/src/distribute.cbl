       IDENTIFICATION DIVISION.
       PROGRAM-ID. DISTRIBUTE.

       DATA DIVISION.
       LINKAGE SECTION.
      *TODO: get the current balance, coefficient AND new balance as an
      *    array, one triplet per jar
       01  LK-CURRENT-BALANCE          PIC S9(13)V99 COMP-3.
       01  LK-TOTAL-AMOUNT             PIC S9(13)V99 COMP-3.
       01  LK-COEFFICIENT              PIC S9(3)V99 COMP-3.
       01  LK-NEW-BALANCE              PIC S9(13)V99 COMP-3.

       PROCEDURE DIVISION USING LK-CURRENT-BALANCE LK-COEFFICIENT
           LK-NEW-BALANCE.
           COMPUTE LK-NEW-BALANCE = LK-CURRENT-BALANCE +
               LK-TOTAL-AMOUNT * LK-COEFFICIENT
           GOBACK.
