      PROGRAM DECM1AAMBER

C  Declare variable type
      INTEGER QMNUM1, QMNUM2, QMATN1, QMATN2, J
      INTEGER LN, IZTYP, IFTYP, IFTYP2, IZ1, IZ2, IZ3, I, ATNUM, IRES
      DOUBLE PRECISION ZPAR, VDWA1, VDWA2, VDWB1, VDWB2, CHA, CHB
      CHARACTER*3 RSNAM, SOLATS
      CHARACTER*2 AMBTY1, AMBTY2
      CHARACTER*30 TITLE
      CHARACTER*80 LINE,LINE2

C  Establish arrays, with max atom length of 3500 atoms
      PARAMETER (MXAT=3500)
      DIMENSION IZTYP(MXAT), IFTYP(MXAT), SOLATS(MXAT), IZ1(MXAT),
     *          IZ2(MXAT), IZ3(MXAT), ZPAR(MXAT,3), IFTYP2(MXAT),
     *          LN(MXAT), IRES(MXAT), RSNAM(MXAT), VDWB1(MXAT),
     *          QMNUM1(MXAT), QMNUM2(MXAT), QMATN1(MXAT),
     *          QMATN2(MXAT), AMBTY1(MXAT), AMBTY2(MXAT),
     *          CHA(MXAT), CHB(MXAT), VDWA1(MXAT), VDWA2(MXAT),
     *          VDWB2(MXAT)
C  Open files
      OPEN (UNIT=IZM, FILE='optzmat', FORM='FORMATTED', STATUS='OLD')
      OPEN (UNIT=99, FILE='zmatol.z', FORM='FORMATTED', STATUS='OLD') 
      OPEN (UNIT=IQM, FILE='decm1out', STATUS='NEW')      

C  Begin parsing through Title and Zmat Coordinates
      READ (IZM,60) TITLE
      I = 0
      J = 0
      K = 0
      WRITE (IQM,60) TITLE
   10 I = I + 1
   11 READ (IZM,70) LINE
      IF (LINE(1:4).EQ.'    ') GO TO 20
      READ (LINE,90) LN(I),SOLATS(I),IZTYP(I),IFTYP(I),IZ1(I),ZPAR(I,1),
     *               IZ2(I),ZPAR(I,2),IZ3(I),ZPAR(I,3),RSNAM(I),IRES(I)
      GO TO 10

C  Variable "I" should be the number of atoms + 1
C  Write out Zmat Coordinates to q-zmat files
   20 ATNUM = I - 1
      DO 21 I = 1, ATNUM
        WRITE (IQM,90) LN(I),SOLATS(I),IZTYP(I),IFTYP(I),IZ1(I),
     *                 ZPAR(I,1),IZ2(I),ZPAR(I,2),IZ3(I),ZPAR(I,3),
     *                 RSNAM(I),IRES(I)
   21 CONTINUE

C  Continue reading and writing (cycle through bottom of zmat)
   30 WRITE (IQM,70) LINE
   31 READ (IZM,70) LINE
      IF (LINE(1:28).EQ.' Final Non-Bonded Parameters')
     *                 GO TO 40
      WRITE (IQM,70) LINE
      GO TO 31

   40 WRITE (IQM,70) LINE
      READ (IZM,70) LINE
      WRITE (IQM,70) LINE
      LINE2=LINE
   41 J = J + 1
   42 READ (IZM,70) LINE
      IF (LINE(1:4).EQ.'    ') GO TO 50
C New Parameters
      READ (LINE,120) QMNUM1(J),QMATN1(J),AMBTY1(J),CHA(J),VDWA1(J),
     *                VDWA2(J)
      GO TO 41       
   
C  Close files
   50 CLOSE (IZM)
   51 READ (99,70) LINE
      IF (LINE(1:28).EQ.' Final Non-Bonded Parameters')
     *                 GO TO 52
      GO TO 51
    
   52 READ (99,70)  
   53 K= K + 1
   54 READ (99,70) LINE
      IF (LINE(1:4).EQ.'    ') GO TO 55
C Old Parameters
      READ (LINE,120) QMNUM2(K),QMATN2(K),AMBTY2(K),CHB(K),VDWB1(K),
     *                VDWB2(K)
      GO TO 53
   55 CLOSE (99)
      ATNUM = J - 1
      DO 56 J = 1, ATNUM
C new, old, old, new, old, old
        WRITE (IQM,120) QMNUM1(J),QMATN2(J),AMBTY2(J),CHA(J),
     *                  VDWB1(J),VDWB2(J)
   56 CONTINUE
      WRITE (IQM,70) LINE2
      CLOSE (IQM)

C  Exit
      STOP
   60 FORMAT (A30)
   61 FORMAT (I4,I4)
   70 FORMAT (A80)
   71 FORMAT (A80, /)
   90 FORMAT (I4,1X,A3,1X,I4,1X,I4,1X,3(I4,F12.6),1X,A3,1X,I4)
  100 FORMAT (/)
  120 FORMAT (I4,1X,I2,1X,A2,1X,3(F10.6))
C  121 FORMAT (F4.0,1X,I2,1X,A2,1X,3(F10.6))
      END
