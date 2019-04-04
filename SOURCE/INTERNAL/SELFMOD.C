/* Peter Kobak  2/18/95
   Demonstration of OS/2 self-modifying code */
#include <os2.h>
#include <stdio.h>

static FuncVal = 4;
static Func(VOID)
{
   FuncVal += 7;
}

INT main(VOID)
{
   const PBYTE pFunc = (PBYTE)(ULONG)Func; /* data! pointer to Func code */
   const BYTE  bNearRet = 0xC3;            /* near return op code */
   APIRET      rc;

   /* make Func code writable, otherwise get an exception */
   rc = DosSetMem( (PVOID)Func, (ULONG)main-(ULONG)Func, PAG_WRITE );
   if (rc) { printf("DosSetMem returned %d\n", rc ); return rc; }

   /* show what Func does before we stomp on it */
   printf("%5d\n",FuncVal);
   Func();
   printf("%5d\n",FuncVal);

   /* nasty part - horrors! - self-modifying code!
      replace Func's first code byte with simple return */
   pFunc[0] = bNearRet;

   /* now Func just returns without doing anything */
   Func();
   printf("%5d\n",FuncVal);
   return 0;
}
