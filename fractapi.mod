IMPLEMENTATION MODULE fractapi ;


FROM Indexing IMPORT Index, InitIndex, LowIndice, HighIndice,
                     PutIndice, GetIndice, FindIndice, IncludeIndiceIntoIndex ;

FROM Storage IMPORT ALLOCATE ;
FROM Fractions IMPORT Fract, initFract, root, unroot, pi, getFract,
                      add, sub, div, negate, mult, dup,
                      isPositive, isNegative, isEqual ;

FROM libc IMPORT printf ;


CONST
   ReUseSlots = TRUE ;
   Trace = FALSE ;

TYPE
   FractDescriptor = POINTER TO RECORD
                                   inuse: BOOLEAN ;
                                   fract: Fract ;
                                   id   : CARDINAL ;
                                END ;

VAR
   RootedFractions: Index ;


(*
   emptySlot - return a slot not in use or 0 if none is available.
*)

PROCEDURE emptySlot () : CARDINAL ;
VAR
   i, high: CARDINAL ;
   fd     : FractDescriptor ;
BEGIN
   IF ReUseSlots
   THEN
      i := LowIndice (RootedFractions) ;
      high := HighIndice (RootedFractions) ;
      WHILE i <= high DO
         fd := GetIndice (RootedFractions, i) ;
         IF NOT fd^.inuse
         THEN
            RETURN i
         END ;
         INC (i)
      END
   END ;
   RETURN 0
END emptySlot ;


(*
   lookupDesc -
*)

PROCEDURE lookupDesc (i: CARDINAL) : FractDescriptor ;
VAR
   fd: FractDescriptor ;
BEGIN
   fd := GetIndice (RootedFractions, i) ;
   IF fd = NIL
   THEN
      printf ("lookupDesc using NIL, aborting\n");
      HALT
   END ;
   RETURN fd
END lookupDesc ;


(*
   initFractDescriptor - create a new FractDescriptor containing value.
                         The FractDescriptor will be stored in the RootedFractions
                         array.
*)

PROCEDURE initFractDescriptor (value: Fract) : FractDescriptor ;
VAR
   fd  : FractDescriptor ;
   slot: CARDINAL ;
BEGIN
   slot := emptySlot () ;
   IF slot = 0
   THEN
      NEW (fd)
   ELSE
      (* We can resuse an unused slot.  *)
      fd := GetIndice (RootedFractions, slot)
   END ;
   (* Now initialize the slot.  *)
   WITH fd^ DO
      inuse := TRUE ;
      fract := root (value)
   END ;
   IncludeIndiceIntoIndex (RootedFractions, fd) ;
   fd^.id := FindIndice (RootedFractions, fd) ;
   IF Trace
   THEN
      printf ("fractdesc is in slot %d\n", fd^.id)
   END ;
   RETURN fd
END initFractDescriptor ;


(*
   Constructor - construct a new fraction with the value whole, numerator and denominator.
*)

PROCEDURE Constructor (whole, numerator, denominator: LONGCARD) : CARDINAL ;
VAR
   fd   : FractDescriptor ;
   value: Fract ;
BEGIN
   value := initFract (whole, numerator, denominator) ;
   fd := initFractDescriptor (value) ;
   RETURN fd^.id
END Constructor ;


(*
   Decon - free the fraction in slot no.
*)

PROCEDURE Decon (no: CARDINAL) ;
VAR
   fd: FractDescriptor ;
BEGIN
   fd := GetIndice (RootedFractions, no) ;
   WITH fd^ DO
      inuse := FALSE ;
      fract := unroot (fract)
   END
END Decon ;


(*
   SetValue - unroots slot no and creates a new fraction with the value
              whole, numerator and denominator in slot no.
*)

PROCEDURE SetValue (no: CARDINAL; whole, numerator, denominator: LONGCARD) ;
VAR
   fd: FractDescriptor ;
BEGIN
   fd := GetIndice (RootedFractions, no) ;
   WITH fd^ DO
      fd^.fract := unroot (fd^.fract) ;
      fd^.fract := initFract (whole, numerator, denominator)
   END
END SetValue ;


(*
   GetValue - assigns the whole, numerator and denominator from fraction at
              slot no.
*)

PROCEDURE GetValue (no: CARDINAL; VAR whole, numerator, denominator: LONGCARD) ;
VAR
   fd: FractDescriptor ;
BEGIN
  (* These three assignments allow gm2 -fswig to determine the direction
     of the parameters.  *)
   whole := 0 ;
   numerator := 0 ;
   denominator := 0 ;
   fd := GetIndice (RootedFractions, no) ;
   WITH fd^ DO
      getFract (fd^.fract, whole, numerator, denominator)
   END
END GetValue ;


(*
   GetWhole - returns the whole number from slot no.
*)

PROCEDURE GetWhole (no: CARDINAL) : LONGCARD ;
VAR
   fd         : FractDescriptor ;
   whole,
   numerator,
   denominator: LONGCARD ;
BEGIN
  (* These three assignments allow gm2 -fswig to determine the direction
     of the parameters.  *)
   whole := 0 ;
   numerator := 0 ;
   denominator := 0 ;
   fd := GetIndice (RootedFractions, no) ;
   WITH fd^ DO
      getFract (fd^.fract, whole, numerator, denominator)
   END ;
   RETURN whole
END GetWhole ;


(*
   GetDenominator - returns the denominator from slot no.
*)

PROCEDURE GetDenominator (no: CARDINAL) : LONGCARD ;
VAR
   fd         : FractDescriptor ;
   whole,
   numerator,
   denominator: LONGCARD ;
BEGIN
  (* These three assignments allow gm2 -fswig to determine the direction
     of the parameters.  *)
   whole := 0 ;
   numerator := 0 ;
   denominator := 0 ;
   fd := GetIndice (RootedFractions, no) ;
   WITH fd^ DO
      getFract (fd^.fract, whole, numerator, denominator)
   END ;
   RETURN denominator
END GetDenominator ;


(*
   GetNumerator - returns the numerator from slot no.
*)

PROCEDURE GetNumerator (no: CARDINAL) : LONGCARD ;
VAR
   fd         : FractDescriptor ;
   whole,
   numerator,
   denominator: LONGCARD ;
BEGIN
  (* These three assignments allow gm2 -fswig to determine the direction
     of the parameters.  *)
   whole := 0 ;
   numerator := 0 ;
   denominator := 0 ;
   fd := GetIndice (RootedFractions, no) ;
   WITH fd^ DO
      getFract (fd^.fract, whole, numerator, denominator)
   END ;
   RETURN numerator
END GetNumerator ;


(*
   PI - returns a special fraction representing pi.
*)

PROCEDURE PI () : CARDINAL ;
VAR
   fd: FractDescriptor ;
BEGIN
   fd := initFractDescriptor (pi ()) ;
   RETURN fd^.id
END PI ;


(*
   dumpFraction -
*)

PROCEDURE dumpFraction (fd: FractDescriptor) ;
VAR
   whole, numerator, denominator: LONGCARD ;
BEGIN
   IF fd^.inuse
   THEN
      getFract (fd^.fract, whole, numerator, denominator) ;
      printf ("%ld %ld/%ld\n", whole, numerator, denominator)
   ELSE
      printf ("not used\n");
   END
END dumpFraction ;


(*
   dumpFractions -
*)

PROCEDURE dumpFractions ;
VAR
   i, high: CARDINAL ;
   fd     : FractDescriptor ;
BEGIN
   IF Trace
   THEN
      i := LowIndice (RootedFractions) ;
      high := HighIndice (RootedFractions) ;
      WHILE i <= high DO
         printf ("slot %03d ", i);
         fd := GetIndice (RootedFractions, i) ;
         dumpFraction (fd) ;
         INC (i)
      END
   END
END dumpFractions ;


(*
   Add - return a new fraction containing the value left + right.
*)

PROCEDURE Add (left, right: CARDINAL) : CARDINAL ;
VAR
   leftDesc,
   rightDesc,
   resultDesc: FractDescriptor ;
BEGIN
   IF Trace
   THEN
      printf ("fractapi.Add (%d, %d)\n", left, right);
      dumpFractions
   END ;
   leftDesc := lookupDesc (left) ;
   IF Trace
   THEN
      printf ("  looked up left\n")
   END ;
   rightDesc := lookupDesc (right) ;
   IF Trace
   THEN
      printf ("  looked up right\n")
   END ;
   resultDesc := initFractDescriptor (add (leftDesc^.fract, rightDesc^.fract)) ;
   IF Trace
   THEN
      printf ("  result in %d\n", resultDesc^.id)
   END ;
   RETURN resultDesc^.id
END Add ;


(*
   Sub - return a new fraction containing the value left - right.
*)

PROCEDURE Sub (left, right: CARDINAL) : CARDINAL ;
VAR
   leftDesc,
   rightDesc,
   resultDesc: FractDescriptor ;
BEGIN
   leftDesc := lookupDesc (left) ;
   rightDesc := lookupDesc (right) ;
   resultDesc := initFractDescriptor (sub (leftDesc^.fract, rightDesc^.fract)) ;
   RETURN resultDesc^.id
END Sub ;


(*
   Div - return a new fraction containing the value left / right.
*)

PROCEDURE Div (left, right: CARDINAL) : CARDINAL ;
VAR
   leftDesc,
   rightDesc,
   resultDesc: FractDescriptor ;
BEGIN
   IF Trace
   THEN
      printf ("fractapi.Div (%d, %d)\n", left, right);
      dumpFractions
   END ;
   leftDesc := lookupDesc (left) ;
   IF Trace
   THEN
      printf ("  looked up left\n")
   END ;
   rightDesc := lookupDesc (right) ;
   IF Trace
   THEN
      printf ("  looked up right\n")
   END ;
   resultDesc := initFractDescriptor (div (leftDesc^.fract, rightDesc^.fract)) ;
   RETURN resultDesc^.id
END Div ;


(*
   Mult - return a new fraction containing the value left * right.
*)

PROCEDURE Mult (left, right: CARDINAL) : CARDINAL ;
VAR
   leftDesc,
   rightDesc,
   resultDesc: FractDescriptor ;
   temp      : Fract ;
BEGIN
   IF Trace
   THEN
      printf ("fractapi.Mult (%d, %d)\n", left, right);
      dumpFractions
   END ;
   leftDesc := lookupDesc (left) ;
   IF Trace
   THEN
      printf ("  looked up left\n")
   END ;
   rightDesc := lookupDesc (right) ;
   IF Trace
   THEN
      printf ("  looked up right\n")
   END ;
   temp := mult (leftDesc^.fract, rightDesc^.fract) ;
   resultDesc := initFractDescriptor (temp) ;
   RETURN resultDesc^.id
END Mult ;


(*
   IsPositive -
*)

PROCEDURE IsPositive (no: CARDINAL) : BOOLEAN ;
VAR
   desc: FractDescriptor ;
BEGIN
   desc := GetIndice (RootedFractions, no) ;
   RETURN isPositive (desc^.fract)
END IsPositive ;


(*
   IsNegative -
*)

PROCEDURE IsNegative (no: CARDINAL) : BOOLEAN ;
VAR
   desc: FractDescriptor ;
BEGIN
   desc := GetIndice (RootedFractions, no) ;
   RETURN isNegative (desc^.fract)
END IsNegative ;


(*
   Negate - returns a new fraction containing -x.
*)

PROCEDURE Negate (x: CARDINAL) : CARDINAL ;
VAR
   desc,
   result: FractDescriptor ;
BEGIN
   desc := lookupDesc (GetIndice (RootedFractions, x)) ;
   result := initFractDescriptor (dup (desc^.fract)) ;
   result^.fract := negate (result^.fract) ;
   RETURN result^.id
END Negate ;


(*
   IsEqual - return TRUE if fraction left = right.
*)

PROCEDURE IsEqual (left, right: CARDINAL) : BOOLEAN ;
VAR
   leftDesc,
   rightDesc: FractDescriptor ;
BEGIN
   leftDesc := lookupDesc (GetIndice (RootedFractions, left)) ;
   rightDesc := lookupDesc (GetIndice (RootedFractions, right)) ;
   RETURN isEqual (leftDesc^.fract, rightDesc^.fract)
END IsEqual ;


(*
   init - initialize the global variables within this module.
*)

PROCEDURE init ;
BEGIN
   RootedFractions := InitIndex (1)
END init ;


BEGIN
   init
END fractapi.
