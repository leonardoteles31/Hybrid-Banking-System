       IDENTIFICATION DIVISION.
       PROGRAM-ID. CALC-INTEREST.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACC-IN  ASSIGN TO "../integration/input/accounts.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT ACC-OUT ASSIGN TO "../integration/output/accounts-interest.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  ACC-IN.
       01  ACC-IN-LINE             PIC X(256).

       FD  ACC-OUT.
       01  ACC-OUT-LINE            PIC X(256).

       WORKING-STORAGE SECTION.
       01  WS-EOF                  PIC X VALUE "N".

       01  WS-ACC-NUM              PIC X(30).
       01  WS-BAL-TXT              PIC X(30).

       01  WS-BAL                  PIC S9(15)V99 COMP-3.
       01  WS-NEW-BAL              PIC S9(15)V99 COMP-3.

       01  WS-RATE                 PIC S9V9(4) COMP-3 VALUE 0.0100.

       01  WS-NEW-BAL-DISP         PIC -9(13).99.

       PROCEDURE DIVISION.
       MAIN.
           OPEN INPUT ACC-IN
           OPEN OUTPUT ACC-OUT

           PERFORM UNTIL WS-EOF = "Y"
               READ ACC-IN
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       PERFORM PROCESS-ACC
               END-READ
           END-PERFORM

           CLOSE ACC-IN
           CLOSE ACC-OUT
           STOP RUN.

       PROCESS-ACC.
           MOVE SPACES TO WS-ACC-NUM WS-BAL-TXT

           UNSTRING ACC-IN-LINE DELIMITED BY ";"
               INTO WS-ACC-NUM WS-BAL-TXT
           END-UNSTRING

           COMPUTE WS-BAL = FUNCTION NUMVAL(WS-BAL-TXT)
           COMPUTE WS-NEW-BAL = WS-BAL + (WS-BAL * WS-RATE)

           MOVE WS-NEW-BAL TO WS-NEW-BAL-DISP

           STRING
               WS-ACC-NUM DELIMITED BY SIZE
               ";"        DELIMITED BY SIZE
               WS-NEW-BAL-DISP DELIMITED BY SIZE
               INTO ACC-OUT-LINE
           END-STRING

           WRITE ACC-OUT-LINE.
