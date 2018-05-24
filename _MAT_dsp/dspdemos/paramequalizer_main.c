/*
** paramequalizer_main.c
*
* Copyright 2011 The MathWorks, Inc.
*/
#include <stdio.h>
#include <stdlib.h>

#include "paramequalizer_initialize.h"
#include "paramequalizer.h"
#include "paramequalizer_terminate.h"

int main()
{
    paramequalizer_initialize();
    paramequalizer();    
    paramequalizer_terminate();
    
    return 0;
}
