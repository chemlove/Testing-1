      PROGRAM LJQANH

CCCCC  Assumes using CM1A charges
CCCCC  Assumes xSPM has been used to expand the zmatrix
CCCCC  "optzmat" is the necessary zmatrix file name

C  Declare variable type
      INTEGER LN, IZTYP, IFTYP, IFTYP2, IZ1, IZ2, IZ3, I, ATNUM, IRES
      INTEGER QMTYP, QMAT, QMNUM, QMTYP2, L, M, CNTR, BONDS, IRES2
      INTEGER II, III
      INTEGER DAT, DINIT, DFNL, D1, D2, D3, D4
      DOUBLE PRECISION ZPAR, QMQ, QMSIG, QMEPS, QMQ2, DVRY
      CHARACTER*3 RSNAM, SOLATS
      CHARACTER*2 ATSYM, ATSYM2
      CHARACTER D
      CHARACTER*30 TITLE
      CHARACTER*80 LINE, LINEVB

C  Establish arrays, with max atom length of 3500 atoms
      PARAMETER (MXAT=3500)
      DIMENSION IZTYP(MXAT), IFTYP(MXAT), SOLATS(MXAT), IZ1(MXAT),
     *          IZ2(MXAT), IZ3(MXAT), ZPAR(MXAT,3), IFTYP2(MXAT),
     *          LN(MXAT), QMTYP(MXAT), QMAT(MXAT), ATSYM(MXAT), 
     *          QMQ(MXAT), QMSIG(MXAT), QMEPS(MXAT), QMQ2(MXAT),
     *          QMTYP2(MXAT), IRES(MXAT), RSNAM(MXAT), ATSYM2(MXAT),
     *          BONDS(MXAT), IRES2(MXAT)

C  Open files
      OPEN (UNIT=IZM, FILE='optzmat', FORM='FORMATTED', STATUS='OLD')
      OPEN (UNIT=IQM, FILE='q-zmat', STATUS='NEW')
      OPEN (UNIT=ILM, FILE='lj-zmat', STATUS='NEW')

C  Begin parsing through Title and Zmat Coordinates
      READ (IZM,60) TITLE
      I = 0
      II = 100
      III = 1
      WRITE (IQM,60) TITLE
      WRITE (ILM,60) TITLE
   10 I = I + 1
   11 READ (IZM,70) LINE
      IF (LINE(1:4).EQ.'    ') GO TO 20
      IF (LINE(1:4).EQ.'TERZ') THEN
      I=I-1
      II=I+1
      III=LN(I)
C     PRINT*, III  
      GO TO 10
      ELSE
      READ (LINE,90) LN(I),SOLATS(I),IZTYP(I),IFTYP(I),IZ1(I),ZPAR(I,1),
     *               IZ2(I),ZPAR(I,2),IZ3(I),ZPAR(I,3),RSNAM(I),IRES(I)
      GO TO 10
      ENDIF

C  Variable "I" should be the number of atoms + 1
C  Write out Zmat Coordinates to q-zmat files
   20 ATNUM = I - 1



      DO 21 I = 1, ATNUM
        IF (IRES(I).EQ.1) THEN
        IFTYP2(I) = IZTYP(I)
        ELSE
        IFTYP2(I) = IZTYP(I) + 50
        ENDIF
C       IF (IZTYP(I).EQ.-1) IFTYP2(I) = -1
        IF (I.EQ.II) THEN
        WRITE (IQM,130) 'TERZ'
        WRITE (ILM,130) 'TERZ'
        ENDIF
        WRITE (IQM,90) LN(I),SOLATS(I),IZTYP(I),IFTYP2(I),IZ1(I),
     *                 ZPAR(I,1),IZ2(I),ZPAR(I,2),IZ3(I),ZPAR(I,3),
     *                 '   ',0
        WRITE (ILM,90) LN(I),SOLATS(I),IZTYP(I),IFTYP2(I),IZ1(I),
     *                 ZPAR(I,1),IZ2(I),ZPAR(I,2),IZ3(I),ZPAR(I,3),
     *                 '   ',0
   21 CONTINUE

C  "LINE" = contains the "Geometry Variations follow" line. Print
C  directly:
      WRITE (IQM,70) LINE
      WRITE (ILM,70) LINE
CCC**INPUT GEOM VARIATION PARMS HERE**


C  Read in Variable line - print for Q, save for LJ
      READ (IZM,70) LINE 
      LINEVB = LINE
C  LINEVB now has variable bond line in it


C  Start reading through variable bond parameters
C  Sort and store to make LJ-geom vars      
      CNTR = 1
   22 READ (IZM,70) LINE
C      IF (LINE(1:4).EQ.'    ') THEN .... finish bond analysis-goto 30
      IF (LINE(1:4).EQ.'    ') THEN
        GO TO 30
C      IF (LINE(5:5).EQ.'-') THEN .... read and treat as an auto
      ELSEIF (LINE(5:5).EQ.'-') THEN
        READ (LINE,91) L,D,M
        DO 25 I = L, M
          BONDS(CNTR) = I
          CNTR = CNTR + 1
   25   CONTINUE

C      IF (LINE(5:5).EQ.' '.AND.LINE(1:4).NE.'    ') THEN .... SINGLE VAR
      ELSEIF (LINE(5:5).EQ.' '.AND.LINE(1:4).NE.'    ') THEN 
        READ (LINE,92) L
        BONDS(CNTR) = L
        CNTR = CNTR + 1
      ELSE
        WRITE(*,*) 'VARIABLE BONDS NOT READ CORRECTLY'
        GO TO 30
      ENDIF
      GO TO 22

C  Print Geom Vars --> Variable Bonds/Additional Bonds
C  q-zmat first
   30 WRITE (IQM,70) LINEVB
      CNTR = CNTR - 1
      DO 31 I = 1, CNTR
        WRITE (IQM,92) BONDS(I)
   31 CONTINUE
      WRITE (IQM,70) LINE

C  lj-zmat second
      DO 32 I = 1, CNTR
        IF (BONDS(I) .GT. III) THEN
        WRITE (ILM,93) BONDS(I),1,0.30
        ENDIF
   32 CONTINUE
      WRITE (ILM,70) LINEVB
      DO 33 I = 1, CNTR
        WRITE (ILM,92) BONDS(I)
   33 CONTINUE
      WRITE (ILM,70) LINE


C  Continue reading and writing (cycle through bottom of zmat)
   35 READ (IZM,70) LINE
C      IF (LINE(1:18).EQ.' Final Non-Bonded') GO TO 40
      IF (LINE(21:45).EQ.'Variable Dihedrals follow') GO TO 40
      WRITE (IQM,70) LINE
      WRITE (ILM,70) LINE
      GO TO 35

C  Stop cycle to adjust dihedral types for lj-zmat
   40 WRITE (IQM,70) LINE
      WRITE (ILM,70) LINE

C  Variable dihedrals first
   41 READ (IZM,70) LINE
      IF (LINE(1:4).EQ.'    ') GO TO 42
      READ (LINE,110) DAT, DINIT, DFNL, DVRY
      WRITE (IQM,110) DAT, DINIT, DFNL, DVRY
      IF (DAT .GT. III) THEN
      WRITE (ILM,110) DAT, DINIT, 100, DVRY
      ELSE
      WRITE (ILM,110) DAT, DINIT, DFNL, DVRY
      ENDIF
      GO TO 41

   42 WRITE (IQM,70) LINE
      WRITE (ILM,70) LINE
C  Additional dihedrals second
   43 READ (IZM,70) LINE
      IF (LINE(1:4).EQ.'    ') GO TO 44
      READ (LINE, 112) D1, D2, D3, D4, DINIT, DFNL
      WRITE (IQM, 112) D1, D2, D3, D4, DINIT, DFNL
      IF (D1 .GT. III) THEN
      WRITE (ILM, 112) D1, D2, D3, D4, DINIT, 100
      ELSE
      WRITE (ILM, 112) D1, D2, D3, D4, DINIT, DFNL
      ENDIF
      GO TO 43

   44 WRITE (IQM,70) LINE
      WRITE (ILM,70) LINE

C  Continue reading/writing line by line
   45 READ (IZM,70) LINE
      IF (LINE(1:18).EQ.' Final Non-Bonded') GO TO 46
      WRITE (IQM,70) LINE
      WRITE (ILM,70) LINE
      GO TO 45



C  Write "Final Non-Bonded..." Line and begin collecting QM parms
   46 WRITE (IQM,71) LINE
      WRITE (ILM,71) LINE
      READ (IZM,70) LINE

      I = 0
   50 I = I + 1
      READ (IZM,70) LINE
      IF (LINE(1:4).EQ.'    ') GO TO 51 
      READ (LINE,120) QMTYP(I), QMAT(I), ATSYM(I), QMQ(I),
     *                QMSIG(I), QMEPS(I)
      GO TO 50
      
C  Write collected QM parameters 
C  I - 1 = number of qm parameters
   51 QMNUM = I - 1



C  Assign IRES3(I). -1, dummy atom; 0, normal atom; 2 or 3, annihilated
C  atom.
      MINDUM = 1
      DO 55 I = 1, ATNUM
        IF (IZTYP(I).NE.-1) THEN
          IF (IZTYP(I).NE.100) THEN
          IRES2(MINDUM) = IRES(I)
C         PRINT *,'IRES2 of non-dummy atoms', IRES2(MINDUM), MINDUM
          MINDUM = MINDUM + 1
          IF (I .EQ. II-2) MINDUM1 =MINDUM 
          ENDIF
        ENDIF
   55 CONTINUE
      MINDUM = MINDUM - 1
      PRINT *, 'Atoms excluding dummy atoms=' ,MINDUM
      IF (MINDUM.NE.QMNUM) WRITE (*,*) 'MINDUM AND QMNUM DO NO EQUAL'

      IF (II.EQ.100) THEN
      PRINT*, 'This is a single molecule.' 
      PRINT*, 'It contains', MINDUM, 'atoms.'
      ENDIF
c
      IF (II.NE.100) THEN
      PRINT*, 'This is a complex.' 
      PRINT*, 'It contains', MINDUM1, 'atoms in the first molecule and',
     *        MINDUM-MINDUM1, 'atoms in the second molecule.'
      ENDIF
      
C  q-zmat first
      DO 52 I = 1, QMNUM
        WRITE (IQM,120) QMTYP(I), QMAT(I), ATSYM(I), QMQ(I),
     *                  QMSIG(I), QMEPS(I)
   52 CONTINUE
      Do 53 I = 1, QMNUM
      IF (IRES2(I).NE.1) THEN
C  Make sure the all system is less than 50 atoms.
        QMTYP2(I) = QMTYP(I) + 50
        QMQ2(I) = 0.00
        WRITE (IQM,120) QMTYP2(I), QMAT(I), ATSYM(I), QMQ2(I), 
     *                  QMSIG(I), QMEPS(I)
      ENDIF
   53 CONTINUE

C  lj-zmat second
      DO 54 I = 1, QMNUM
      IF (IRES2(I).EQ.1) THEN
        WRITE (ILM,120) QMTYP(I), QMAT(I), ATSYM(I), QMQ(I),
     *                  QMSIG(I), QMEPS(I)
        ELSE
        WRITE (ILM,120) QMTYP(I), QMAT(I), ATSYM(I), QMQ2(I),
     *                  QMSIG(I), QMEPS(I)
      ENDIF
   54 CONTINUE

      DO 56 I = 1, QMNUM
C       Following line set up for when you want to change ATSYM based on
C       IRES information
        QMAT(I) = 99
        IF (IRES2(I).EQ.2)  THEN
          ATSYM2(I) = 'DM'
        WRITE (ILM,120) QMTYP2(I), QMAT(I), ATSYM2(I), QMQ2(I),
     *                  QMQ2(I), QMQ2(I)
        ELSEIF (IRES2(I).EQ.3)  THEN
          ATSYM2(I) = 'D3'
        WRITE (ILM,120) QMTYP2(I), QMAT(I), ATSYM2(I), QMQ2(I),
     *                  QMQ2(I), QMQ2(I)
        ELSE
          ATSYM2(I) = ATSYM(I)
        ENDIF
C       WRITE (ILM,120) QMTYP2(I), QMAT(I), ATSYM2(I), QMQ2(I),
C    *                  QMQ2(I), QMQ2(I)
   56 CONTINUE


C  Finish zmat with blank line
      WRITE (IQM,70) LINE
      WRITE (ILM,70) LINE
C      WRITE (IQM,60) 'THIS IS THE END OF THE TEST'
C      WRITE (ILM,60) 'THIS IS THE END OF THE TEST'

C  Close files
      CLOSE (IZM)
      CLOSE (IQM)
      CLOSE (ILM)

C  Exit
      STOP
   60 FORMAT (A30)
   70 FORMAT (A80)
   71 FORMAT (A80, /)
   90 FORMAT (I4,1X,A3,1X,I4,1X,I4,1X,3(I4,F12.6),1X,A3,1X,I4)
   91 FORMAT (I4,A,I4)
   92 FORMAT (I4)
   93 FORMAT (I4,I4,F6.2)
  100 FORMAT (/)
  110 FORMAT (I4,I4,I4,F12.6)
  112 FORMAT (6I4)
  120 FORMAT (I4,1X,I2,1X,A2,1X,3(F10.6))
  130 FORMAT (A4)
      END
