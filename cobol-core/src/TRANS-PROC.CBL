       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRANS-PROC.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IN-FILE ASSIGN TO 
               "../integration/input/transactions.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-IN-STATUS.
           SELECT OUT-FILE ASSIGN TO 
               "../integration/output/result2.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-OUT-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  IN-FILE.
       01  IN-LINE                 PIC X(256).

       FD  OUT-FILE.
       01  OUT-LINE                PIC X(256).

       WORKING-STORAGE SECTION.
       01  WS-EOF                  PIC X VALUE "N".

       01  WS-TX-ID                PIC X(30).
       01  WS-TX-TYPE              PIC X(15).
       01  WS-TX-AMOUNT            PIC X(30).
       01  WS-TX-FROM              PIC X(30).
       01  WS-TX-TO                PIC X(30).
       01  WS-TX-TS                PIC X(40).

       01  WS-AMOUNT               PIC S9(15)V99 COMP-3.

       01  WS-STATUS               PIC X(10).
       01  WS-IN-STATUS            PIC XX.
       01  WS-OUT-STATUS           PIC XX.
       01  WS-MSG                  PIC X(120).

       PROCEDURE DIVISION.
       MAIN.
           OPEN INPUT IN-FILE
           IF WS-IN-STATUS NOT = "00"
               DISPLAY "ERROR OPENING INPUT FILE: " WS-IN-STATUS
               STOP RUN
           END-IF

           OPEN OUTPUT OUT-FILE
           IF WS-OUT-STATUS NOT = "00"
               DISPLAY "ERROR OPENING OUTPUT FILE: " WS-OUT-STATUS
                STOP RUN
           END-IF

           PERFORM UNTIL WS-EOF = "Y"
               READ IN-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                       DISPLAY "END OF FILE REACHED"
                   NOT AT END
                       DISPLAY "READ SUCCESS: " IN-LINE 
                       PERFORM PROCESS-LINE
               END-READ
           END-PERFORM

           CLOSE IN-FILE
           CLOSE OUT-FILE
           STOP RUN.

       PROCESS-LINE.
           DISPLAY "Processing: " IN-LINE 
           MOVE SPACES TO WS-TX-ID WS-TX-TYPE WS-TX-AMOUNT
                           WS-TX-FROM WS-TX-TO WS-TX-TS
           MOVE SPACES TO WS-STATUS WS-MSG

           UNSTRING IN-LINE DELIMITED BY ";"
               INTO WS-TX-ID
                    WS-TX-TYPE
                    WS-TX-AMOUNT
                    WS-TX-FROM
                    WS-TX-TO
                    WS-TX-TS
           END-UNSTRING

           PERFORM VALIDATE-RECORD

           MOVE SPACES TO OUT-LINE 

           DISPLAY "ID=[" WS-TX-ID "] TYPE=[" WS-TX-TYPE "]"
           STRING
               FUNCTION TRIM(WS-TX-ID)     DELIMITED BY SIZE
               ";"                         DELIMITED BY SIZE
               FUNCTION TRIM(WS-STATUS)    DELIMITED BY SIZE
               ";"                         DELIMITED BY SIZE
               FUNCTION TRIM(WS-MSG)       DELIMITED BY SIZE
               INTO OUT-LINE
           END-STRING

           WRITE OUT-LINE.

       VALIDATE-RECORD.
           MOVE "PROCESSED" TO WS-STATUS
           MOVE "OK"        TO WS-MSG

           EVALUATE WS-TX-TYPE
               WHEN "TRANSFER"
                   CONTINUE
               WHEN "DEPOSIT"
                   CONTINUE
               WHEN "WITHDRAW"
                   CONTINUE
               WHEN OTHER
                   MOVE "FAILED" TO WS-STATUS
                   MOVE "Invalid transaction type" TO WS-MSG
                   EXIT PARAGRAPH
           END-EVALUATE

           COMPUTE WS-AMOUNT = FUNCTION NUMVAL(WS-TX-AMOUNT)
           IF WS-AMOUNT <= 0
               MOVE "FAILED" TO WS-STATUS
               MOVE "Amount must be > 0" TO WS-MSG
               EXIT PARAGRAPH
           END-IF

           IF WS-TX-TYPE = "TRANSFER"
               IF WS-TX-FROM = SPACES OR WS-TX-TO = SPACES
                   MOVE "FAILED" TO WS-STATUS
                   MOVE "TRANSFER requires from and to" TO WS-MSG
                   EXIT PARAGRAPH
               END-IF
           END-IF

           IF WS-TX-TYPE = "WITHDRAW"
               IF WS-TX-FROM = SPACES
                   MOVE "FAILED" TO WS-STATUS
                   MOVE "WITHDRAW requires from" TO WS-MSG
                   EXIT PARAGRAPH
               END-IF
           END-IF

           IF WS-TX-TYPE = "DEPOSIT"
               IF WS-TX-FROM = SPACES
                   MOVE "FAILED" TO WS-STATUS
                   MOVE "DEPOSIT requires target account" TO WS-MSG
                   EXIT PARAGRAPH
               END-IF
           END-IF.
