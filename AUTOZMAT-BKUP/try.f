
      PROGRAM LJQANH

CCCCC  Assumes using CM1A charges
CCCCC  Assumes xSPM has been used to expand the zmatrix
CCCCC  "optzmat" is the necessary zmatrix file name

C  Declare variable type
      INTEGER LN, IZTYP, IFTYP, IFTYP2, IZ1, IZ2, IZ3, I, ATNUM, IRES
      INTEGER QMTYP, QMAT, QMNUM, QMTYP2, L, M, CNTR, BONDS, IRES2
      INTEGER J
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
      J = 100
      WRITE (IQM,60) TITLE
      WRITE (ILM,60) TITLE
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
