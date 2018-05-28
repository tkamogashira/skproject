/*************************************************************
  APLD

  Loads AP.OBJ from the current directory to the AP2.

  Exit codes are as follows:
    Exit codes:  0 ok
                 1 incorrect syntax
                 2 can't initialize AP2

  Note:  Must be compiled with the Large or Compact memory model

  HISTORY
  18aug93 v1.0
  14apr97 v1.1
     add exit codes for consistency with other updated programs
     don't print syntax unless an error in syntax is detected
*************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <dos.h>
#include <string.h>

#define   BLOCKSIZE  30000

typedef struct
{
  unsigned short f_magic;
  unsigned short f_nscs;
  long           f_timdat;
  long           f_symptr;
  long           f_nsyms;
  unsigned short f_opthrd;
  unsigned short f_flags;
} filehdr;

typedef struct
{
  char           s_name[8];
  long           s_paddr;
  long           s_vaddr;
  long           s_size;
  long           s_scnptr;
  long           s_relptr;
  long           s_lnnoptr;
  unsigned short s_nreloc;
  unsigned short s_nlnno;
  long           s_flags;
} scnhdr;

long      i,j,k;
FILE      *fff;
long      adr,nwds,bpts;
unsigned  z[BLOCKSIZE];
int        base;
int        act[2];
int        dev;
filehdr   fh;
scnhdr    sh[5];
int        qap1;


void showSyntax ()
// QAP not listed in syntax to reduce potential for confusion
{
  printf ("* Error in syntax:\n");
	printf ("    Usage: APLD [APa] [APb]\n");
  printf ("* Array processor not initialized.\n\n");

  exit (1);
}

void setaddr(long adr)
{
  outportb(base+0x0B,(adr >> 16) & 0xff);
  outport(base+0x00,adr);
}

void dataout(unsigned int z[], unsigned ioport, unsigned count)
{
  unsigned int i;
  for(i=0; i<count; i++)
  {
    outport(ioport,z[i]);
  }
}

void main(int argc, char *argv[], char *env[])
{
  printf ("\n\nAPLD v1.1  AP2 Initialization\n\n");

  act[0]=0; act[1]=0; qap1=0;

  if(argc==1)   // now require that there be one and only one argument
  {
    showSyntax ();
  }
  else
  // lower case preserved here for backwards compatiblity
  {
    for(i=1; i<argc; i++)
    {
      if(!strcmp(argv[i],"A") || !strcmp(argv[i],"a"))
        act[0]=1;
      else if(!strcmp(argv[i],"B") || !strcmp(argv[i],"b"))
        act[1]=1;
			else if(!strcmp(argv[i],"APa") || !strcmp(argv[i],"apa"))
        act[0]=1;
			else if(!strcmp(argv[i],"APb") || !strcmp(argv[i],"apb"))
        act[1]=1;
      else if(!strcmp(argv[i],"QAP1") || !strcmp(argv[i],"qap1"))
        qap1=1;
      else
        showSyntax();
    }
  }

//  if(!act[0] && !act[1]) act[0]=1;  // no default values allowed

  for(dev=0; dev<2; dev++)
  {
    if(act[dev])
    {
      base=0x220+(dev << 5);
      if(qap1)
        if(dev==0)
          printf("  Loading QAP1a...");
        else
          printf("  Loading QAP1b...");
      else
        if(dev==0)
          printf("  Loading AP2a...");
        else
          printf("  Loading AP2b...");

      if(qap1)
      {
        outportb(base+0xe,2);
        for(i=0; i<1000; i++);
        outportb(base+0x0e,0);
        for(i=0; i<1000; i++);
        outportb(base+0x0e,2);
        for(i=0; i<1000; i++);

        outportb(base+0x07, 0x1b);
        outportb(base+0x0a, 0x00);
        outportb(base+0x0e, 0x02);
      }
      else
      {
        outportb(base+0x12,4);
        for(i=0; i<1000; i++);
        outportb(base+0x12,0);
        for(i=0; i<1000; i++);
        outportb(base+0x12,4);
        for(i=0; i<1000; i++);

        outportb(base+0x07, 0x1b);
        outportb(base+0x0a, 0x02);
        outportb(base+0x12, 0x05);
      }

      fff=fopen("ap.obj","rb");
      if(!fff)
      {
        printf ("failed!\n\n");
        printf("*  AP.OBJ not found!\n\n");
        exit(2);
      }

      fread(&fh,sizeof(filehdr),1,fff);
      fread(sh,sizeof(scnhdr),fh.f_nscs,fff);

      for(i=0; i<fh.f_nscs; i++)
      {
        setaddr(sh[i].s_paddr);
        nwds = sh[i].s_size >> 1;
        if(sh[i].s_size & 1)
        {
          printf ("failed!\n\n");
          printf("*  APOS onboard code file corrupted!\n\n");
          exit(2);
        }
        do
        {
          bpts = nwds;
          if(bpts > BLOCKSIZE) bpts = BLOCKSIZE;
          nwds = nwds - bpts;
          fread(z, 2, bpts, fff);
          dataout(z,base+0x02,(unsigned int)bpts);
        }while(nwds>0);
      }
      fclose(fff);
      if(qap1)
      {
        outportb(base+0x0e,0x03);
        for(i=0; i<1000; i++);
        outportb(base+0x07,3);
        outportb(base+0x0a,0);
      }
      else
      {
        outportb(base+0x12,0x07);
        for(i=0; i<1000; i++);
        outportb(base+0x07,3);
        outportb(base+0x0a,2);
      }
      i=30000;
      do
      {
        if(!(i--))
        {
          printf ("failed!\n\n");
          printf("*  Array Processor not responding after code loading!\n\n");
          exit(2);
        }
      }while(inport(base+0x08)!=1110);
      if(!qap1)
        outportb(base+0x12,0x0f);
    }
  }
//  printf("\n\n");

  printf ("ok\n\n");
  exit (0);
}
