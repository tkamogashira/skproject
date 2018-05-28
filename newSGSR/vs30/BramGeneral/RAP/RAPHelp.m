%   List of implemented RAP commands :
%   ----------------------------------
%
%   Standard Commands:   
%   
%   HELP                      Displays this help text
%   MORE ON/OFF               Paging of the output in the command window (*)
%   DF @@@...@@@              Specify data file name
%   UD                        Update current data file
%   ID @@@...@@@ [ERR=#]      Specify data set ID. Optionally branch to specified 
%                             record in macro on error
%   DS #                      Specify dataset number
%   NX DS [ERR=#]             Next dataset
%   PV DS [ERR=#]             Previous dataset (*)
%   SWP                       Swap foreground and background dataset
%   SYNC [AUTO/MAN]           Synchronize calculation parameters for current dataset
%                             with userdata interface (*)
%   MASH #                    Create new dataset in memory collapsing # spiketrains
%                             of current dataset into 1 (*)
%   AW #1 #2 [#3 #4 ...]      Specify analysis window (msecs)
%   AW DEF                    Default value for analysis window
%   RW #1 #2 [#3 #4 ...]      Specify reject window (msecs)
%   RW DEF                    Default value for reject window
%   SUB #                     Subtract constant from each spike time before analysis
%                             (in millisecs)(default=0)
%   TR #1 #2 [#3 #4 ...]      Specify trials to be included in analyses
%   TR DEF                    Default value for trial numbers
%   MIN IS #                  Minimum Interspike Interval allowed (millsecs)
%   PER PKL #		          Percent for peak latency computation
%   PER PKL DEF		          Default percent for peak latency
%   SM PKL #		          Smoothing for peak latency computation
%   SM PKL DEF		          Default smoothing for peak latency computation
%   SM LIN #		          Smoothing for data lines
%   SM LIN DEF		          Default smoothing for data lines
%   SM HI #		              Smoothing for histograms (*)
%   SM HI DEF		          Default smoothing for histograms (*)
%   SM ENV #                  Smoothing for envelope of difcor (*)  
%   SM ENV DEF                Default smoothing for envelope of difcor (*)
%   CR #                      Significance level for coincidence rate plot (*)
%   CR DEF                    Default significance level for coincidence rate plot (*)
%   BOOT #                    Bootstrap for coincidence rate plot (*)
%   BOOT DEF                  Default bootstrap for coincidence rate plot (*)
%   XN #                      Minimum value along X-axis
%   XN DEF                    Default value for X-minimum
%   XM #                      Maximum value along X-axis
%   XM DEF                    Default value for X-maximum
%   YN #                      Minimum value along Y-axis
%   YN DEF                    Default value for Y-minimum
%   YM #                      Maximum value along Y-axis
%   YM DEF                    Default value for Y-maximum
%   TINC X #                  Tic increment along X-axis
%   TINC X DEF                Default Tic increment along X-axis
%   TINC Y #                  Tic increment along Y-axis
%   TINC Y DEF                Default Tic increment along Y-axis
%   AUTO XX                   Auto-scaling for X-axis
%   AUTO YX                   Auto-scaling for Y-axis
%   AUTO AX                   Auto-scaling for X-, Y-axis
%   LOG XX/YX                 X-,Y-axis to be Log
%   LIN XX/YX                 X-,Y-axis to be linear
%   FLIP XX                   Flip X-axis (*)
%   NB #                      No. of bins in histogram
%   NB DEF                    No. of histogram bins to default
%   BW #                      Binwidth in ms for histogram
%   BWCOR #                   Binwidth in ms for autocorrelograms
%   BWCOR DEF                 Binwidth to default
%   MLCOR #                   Maximum lag in ms for autocorrelograms
%   MLCOR DEF                 Maximum lag to default
%   RY #                      Rayleigh criterion for cyclehistograms and phase curves
%   RY DEF                    Rayleigh criterion to default
%   CYCLINT YES/NO            Integer number of cycles for analysis window on or off (*)
%   CYCLINT DEF               Integer number of cycles for analysis window to default (*)
%   PHCONV LEAD/LAG           Set phase convention to lead or lag (*)
%   PHCONV DEF                Set phase convention to default (*)
%   COMDEL #                  Set compensating delay (*)
%   COMDEL DEF                Set compensating delay to default (*)
%   UP YES/NO/DEF             Unwrap phase (*)
%   PP #	                  Plots per page
%   PP # #                    Plots/page in X and Y-direction (*)
%   PP X #                    Plots/page in X-direction
%   PP Y #                    Plots/page in Y-direction
%   PP X/Y DEF                Plots/page in X- or Y-dir to default
%   PP DEF                    Plots/page to default along X- and Y-direction
%   RR DEF			          Default range for X- and Y-variables
%   RR X #1 [#2] [#3]	      Re-set range of X-variable
%   RR Y #1 [#2] [#3]	      Re-set range of Y-variable
%   RR SEQ #1 [#2] [#3]	      Re-set range of stimulus points
%   RR SEQ DEF		          Def. range for stim. points (all of them) 
%   Semantics of RR command:
%   The subsequence numbers are not changed by multiple independent variables, cause
%   they are ordered by stimulus presentation. The command RR does work a little bit
%   different for two independent variables, when specifying an X or an Y range the 
%   range restriction is narrowed down instead of resetting the range. This is not
%   the case for specifying a range with subsequences.
%   For independent variables with a logaritmic scale, the step size is given in
%   octaves.
%   HI BF @@..@@              Binning freq for cyc histograms supplied as expression
%   HI BFI #1 #2              Binning freq for cyc histograms to start at #1 Hz and
%                             increase by #2 Hz each time
%   HI BFV #1 [#2 ...]        Binning freq for cyc histograms supplied as vector of 
%                             constant values. Length must be equal to number of recorded
%                             subsequences (*)
%   HI BF DEF                 Histogram binning frequency to default
%   HI SH #                   Histograms to be shaded using specified color
%   HI SH DEF                 Histogram shading to default  
%   HI UN                     Histograms to be unshaded
%   HI OUT/FULL               Histogram outlines only or full bars
%   HI HI/LI                  Histogram or line plot (*)
%   HI YV RATE/COUNT/NORM     Hist. Y-axis to be spike rate,count or normalized
%   SET DEF                   Set all parameters to default
%   SET YLOC RIGHT/LEFT       Plot axis to use as the Y-axis
%   SET YLOC DEF              Set plot Y-axis to default
%   SET TXT @@ UL/UR/LL/LR    Set location of any of the following (*)
%                               SSQ  : Subsequence information                        
%                               CLC  : Calculation parameters of foreground dataset
%                               CLC2 : Calculation parameters of background dataset
%                               EXT  : Extracted data
%   SET TXT @@ ON/OFF         Display any of the following (*)
%                               SSQ : Subsequence information                        
%                               CLC : Calculation parameters of foreground dataset
%                               CLC2 : Calculation parameters of background dataset
%                               EXT : Extracted data
%   SET TI "..." [V#/C# "..." V#/C# ...]    Set value of title
%   SET XLBL "..." [V#/C# "..." V#/C# ...]  Set value of X-axis label
%   SET YLBL "..." [V#/C# "..." V#/C# ...]  Set value of Y-axis label
%   SET TI/XLBL/YLBL DEF      Set specified title or label to default
%   SET RGL WIN #1 #2	      Averagng wndow for regularity analysis
%   SET RGL WIN DEF	          Set averaging window to default
%   SET RGL MINSPK #          Min. intervals/bin for regl. analysis
%   SET RGL MINSPK DEF        Min. spikes for regularity to default
%   SET PKL SRW #1 #2         Window for spon. rate estimation for peak latency computation (*)
%   SET PKL SRW DEF           Window for spon. rate estimation to default (*)
%   SET PKL PKW #1 #2         Peak window for peak latency computation (*)
%   SET PKL PKW DEF           Peak window to default (*)
%   SET TH Q #                Thresold for Q-factor estimation (*)
%   SET TH Q DEF              Default threshold for Q-factor (*)
%   SET SYNC THR #            Set cutoff threshold on synchronisation curve (*)
%   SET SYNC THR DEF          Default cutoff threshold on synchronisation curve (*)
%   SET SP ERR ON/OFF/DEF     Plot or do not plot error bars on rate level curves (*)
%   LW @@ #		              Line weights of any of the following (*)
%	                			AX   : All axes
%         	                    TH   : Threshold curve
%                               SP   : Rate curve
%                               RAS  : Raster plot
%                               SC   : Correlograms
%                               VS   : Vector strength curves
%                               SCP  : Scatterplot
%                               AW   : Analysis window
%                               ERR  : Error bars
%                               ALL  : All of the above
%   LW @@ DEF		          Default line wts for any of the above
%   STYLE LI @@ @             Line styles of any of the following (*)
%         	                    TH   : Threshold curve
%                               SP   : Rate curve
%                               SC   : Correlograms
%                               VS   : Vector strength curves
%                               SCP  : Scatterplot
%                               AW   : Analysis window
%                               ERR  : Error bars
%                               ALL  : All of the above
%   STYLE LI @@ DEF		      Default line style for rate plot (*)
%   SYM DOT @@ @              Marker style for any of the following (*)
%         	                    TH   : Threshold curve
%                               SP   : Rate curve
%                               SC   : Correlograms
%                               VS   : Vector strength curves
%                               SCP  : Scatterplot
%                               ALL  : All of the above
%   SYM DOT @@ DEF		      Default marker style for any of the above (*)
%   FONT @@ @@@...@@@ 		  Character Font name of any of : (*)
%                               HDR  : Header
%                               TI   : Plot title
%                               LBL  : Label along all axes
%			                	XLBL : Label along X-axis
%	                			YLBL : Label along Y-axis
%                    			TIC  : Tick labels along all axes
%                               TXT  : Plot text
%                               ALL  : All of the above
%   FONT @@ DEF		          Default font for any of the above
%   SZ @@ # 		          Font size of any of : (*)
%                               HDR  : Header
%                               TI   : Plot title
%                               LBL  : Label along all axes
%			                	XLBL : Label along X-axis
%	                			YLBL : Label along Y-axis
%                    			TIC  : Tick labels along all axes
%                               TXT  : Plot text
%                               ALL  : All of the above
%   SZ @@ DEF		          Default font for any of the above (*)
%   COL @@ @		          Color for any of the following : (*)
%                               HDR  : Header
%               				XX   : X-axis
%               				YX   : Y-axis
%               				AX   : All axes
%               				XLBL : Label along X-axis
%               				YLBL : Label along Y-axis
%               				TI   : Title
%               				TXT  : Text
%                               TH   : Line of threshold curve
%                               SP   : Line of rate curve
%               				HI   : Histogram edges
%                               SC   : Line of correlograms
%                               VS   : Line of vector strength curves
%                               SCP  : Scatterplot
%                               AW   : Analysis window
%                               ERR  : Error bars
%                               ALL  : All of the above           
%   COL @@ DEF		          Default Colors for any of the above
%
%   Invoking these standard commands without any input arguments results in the data, that is 
%   normally manipulated by the command, only being displayed on the command window. No parameters
%   are altered. The command SET without any input arguments gives an overview of the current
%   RAP settings.
%
%   Output Commands
%
%   SOU #1 #2                 Set output plot to nr #1 along X-axis and nr #2 along Y-axis (*)
%   SOU DEF                   Set output plot to the upper left plot (*)
%   SOU NX                    Set output plot to the next plot, following row order (*)
%   SOU NEW FIG               Starts new figure, but keeps the current figure settings (*)
%   CLO [CUR]                 Closes the current RAP figure (*)
%   CLO ALL                   Closes all figures generated by RAP (*)
%   PR [CUR]                  Print current RAP figure (*)
%   PR ALL                    Print all RAP figures (*)
%   OU DI                     Output directory (display all information)
%   OU DI @@...@@ [@@..@@ ...]Directory output restricted to entries containing
%                             the given string. A list of extra substitution variables
%                             to display can be given.
%   OU DI # [@@..@@ ...]      Directory output restricted to given cell-number. A list
%                             of extra substitution variables
%                             to display can be given.
%   OU DS [@@@...@@@/#]       Output directory (display only dataset number)
%   OU ID [@@@...@@@/#]       Output directory (display only dataset identifiers)
%   OU TH			          Output Threshold (Tuning) curve plot
%   OU SP [COUNT/RATE]        Output spike counts or rates vs. variable
%   OU RAS                    Output dot raster
%   OU SYNC/SY	              Output Sync. Coeff. vs variable
%   OU PHASE/PH		          Output Phase vs. variables
%   OU PST/PS		          Output Post Stimulus Time Histograms
%   OU ISI			          Output Inter-spike interval Histograms
%   OU CH			          Output Cycle (or Phase) Histograms
%   OU POL                    Output Polar Cycle (or Phase) plot (*)
%   OU CHD                    Output Cycle Histogram Dot raster
%   OU LAT 		       	      Output First Spiketime Latency Histograms
%   OU SAC [COUNT/RATE/NORM]  Output Shuffled AutoCorrelation
%   OU XC [COUNT/RATE/NORM]   Output CrossCorrelation
%   OU DIF [COUNT/RATE/NORM]  Output DifCor (*)
%   OU RGL [CV]		          Regularity analysis (CV vs time)
%   OU RGL MEAN		          Regularity analysis (Mean & St.dev)
%   OU PKL                    Peak latency plot (*)
%   OU TRD [COUNT/RATE]       Output Trial Rate Distribution (*)
%   OU SCP @@..@@ @@..@@      Output Scatterplot (*)
%   OU CR [NORM/COUNT]        Output Coincidence Rate (*)
%   OU SR [COUNT/RATE]        Output Sync Rate (*)
%   OU RY                     Output Rayleigh statistics (*)
%   NL @@                     Any of the above to Null device
%   PL @@                     Any of the above directly to printer (NOT YET IMPLEMENTED)
%
%   Macro Commands
%
%   GV V#/C#  @@..@@ [ERR=#]  Get value of specified 	
%				              variable and store in specified 	
%				              variable. Optionally branch to record 
%				              # in macro on error condition
%   GV V#/C# [ERR=#]          Show value of specified variable (*)
%   DI V#/C# [ERR=#]          Show value of specified variable (*)
%   V# = @@..@@               Set value of variable
%   V#1 @ V#2		          Replace V#1 using arithmetic opert. 
%                             (@ can be any one of +, -, *, /)
%   V#1 GCF V#2		          Compute Greatest Common Factor
%   C# = @@@...@@@		      Set value of character variable
%   C#1 + C#2	              Append C#2 to C#1 and store back in C#1
%   EXP V#/C# "..." [V#/C# "..." V#/C# ...] Export variable to MATLAB base
%                             workspace (*)
%   ES @@..@@ V#/C# [V#/C# ...] Export list of memory- and/or substitution-
%                             variables as an extra row of a structure-array
%                             @@..@@ in the MATLAB base workspace (*)
%   IF @@@1 EQ/NE/GT/LT/LE/GE @@@2 @@@@3	If the variable @@@1
%					          satisfies the given condition then 
%					          execute the command @@@@3
%   EM @@..@@		          Execute (run) specified macro
%   ED @@..@@		          Edit specified macro (*)
%   GO #	    	          Branch to specified record
%   GO @@..@@   	          Branch to specified label 
%   PAUSE                     Pause execution of script (*)
%   ECHO ON/OFF               Turns on/off echoing of commands inside macro
%   ECHO "..." [V#/C# "..." V#/C# ...] Displays text on the command window (*)
%   RETURN			          Return from macro, or, if at level-1, then
%			                  exit from RAP
%
%   Invoking GV without any input arguments gives a list of all memory variables currently 
%   defined in RAP.
%   Labels can be specified by adding the following prefix to any RAP command: 
%                                   @@..@@: [RAP Command]
%   Where @@..@@ is the label-identifier. This identifier must be case-insensitive and must
%   be unique within a macro. A label definition need not always be followed by a command.
%   In the ERR=# postfix, to record to branch to when an error occurs, can also be defined
%   by a label. The following syntax should be used: ERR=@@..@@ .
%
%   EXIT, EX, END or QUIT     Exit from RAP
%
%   Commands that are followed by an asteriks (*) are not defined in the original RAP
%   language, but are included to facilitate standard manipulations, or they are defined
%   but have a slightly different implementation. If applicable an input argument to a
%   command can always be replaced by a memory variable of the same type. Exceptions to this 
%   rule are all commands taking line numbers as input (e.g. GO or ERR=#) and commands taking
%   filenames as inputs (like DF and EM). Labels cannot be specified with memory variables.
%   When the first character of a command line is an exclamation mark, then everything after
%   this character is interpreted as a MATLAB statement and is invoked by the MATLAB interpreter
%   in the base workspace. References to RAP memory variables are allowed in these MATLAB 
%   statements.
%
%
%   List of implemented RAP substitution variables :
%   ------------------------------------------------
%
%	FNAME	: Name of current data file (char string)
%	NUMDS	: Total number of data sets in file
%	DSID	: Data set ID of current data set (char string)
%   CELLNR  : Cell number of current dataset (~)
%	EXTYP	: Experiment type (char string)
%   YEAR    : Year in which current data set collected (4 digits)
%	NDSET	: Number of the current data set
%   NSTIM	: No. of stimulus points in current dataset
%   NSTIMR  : No. of recorded stimulus points in current dataset (~)
%   NSTIMA  : No. of stimulus points actually included in recent analysis
%	NREPS	: Number of repetitions
%	NREP	: Same as NREPS
%   NUMV    : Number of RA variables
%	XNAME	: Name of X-variable (char string)
%	XLOW	: Starting value for X-variable
%	XHIGH	: Final value for X-variable
%	XINC	: Increment for X-variable (or steps/octave if log steps)
%   XSCALE  : Scale for X-variable (char string)(~)
%	XRANGE	: Range of X-variable
%	NUMX	: No. of times X-variable was varied
%	YNAME	: Name of Y-variable (char string)
%	YLOW	: Starting value for Y-variable
%	YHIGH	: Final value for Y-variable
%	YINC	: Increment for Y-variable (or steps/octave if log steps)
%   YSCALE  : Scale for Y-variable (char string)(~)
%	YRANGE	: Range of Y-variable
%	NUMY	: Number of times Y-variables was varied
%	STMDUR	: Stimulus duration (millisecs) (*)
%	DUR	    : Stimulus duration (millisecs) (*)
%	REPINT	: Repetition interval (millisecs) (*)
%	RTIME	: Stimulus envelope Rise time (millisecs) (*)
%	FTIME	: Stimulus envelope Fall time (millisecs) (*)
%	DELAY	: Initial delay of Master DSS (*)
%	SPL	    : Fixed SPL (dB) (*)
%	FCARR	: Carrier frequency (Hz) (*)
%	FREQ	: Fixed frequency (Hz) (*)
%	PHASE	: Carrier initial phase (0 to 1) (*)
%	DMOD	: Depth of modulation (*)
%	FMOD	: Fixed modulation frequency (*)
%	PHASM	: Modulation initial phase (0 to 1) (*)
%	PHASEM	: Same as PHASM (*)
%   NUETS   : Number of unit event timers (~)
%   UETNRS  : Unit event timer numbers (~)
%	GWFILE	: General waveform File-name (char string) (*)
%	GWID	: General waveform ID (char string) (*)
%   GWLEN   : General Waveform length
%   GWINT   : General Waveform interval (microsecs)
%   GPGWI1  : First Waveform ID from Gewab-pair expt. (char) (~)
%   GPGWI2  : Second Waveform ID from Gewab-pair expt. (char) (~)
%   ITRATE  : ITD rate for shifted-GW stimulus (microsecs/sec)
%   SGITD1  : Shifted-GW ITD1 for shifted-GW stimulus (microsecs)
%   SGITD2  : Shifted-GW ITD2 for shifted-GW stimulus (microsecs)
%   MDSS    : Master DSS number (~)
%   DSS1    : DSS-1 use flag (0 or 1) (~)
%   DSS2    : DSS-2 use flag (0 or 1) (~)
%   XVAR    : Table of X-var values from current dataset (array)
%   YVAR    : Table of Y-var values from most recent plot (array)
%   THCF    : Characteristic frequency from Tuning curve data (~)
%   THTHR   : Minimum threshold from Tuning curve data (~)
%   THQ     : Estimated Q-factor from Tuning curve data (~)
%   THBW    : Estimated bandwidth from Tuning curve data (~)
%   THSPON  : Spon. Activity Count from TH data (~)
%	VALMAX	: Largest value from most recent RA plot
%	VALMIN	: Minimum value from most recent RA plot
%	XVMAX	: Value of X-var at VALMAX from RA plot
%	XVMIN	: Value of X-var at VALMIN from RA plot
%	YVMAX	: Value of Y-var at VALMAX from RA plot
%	YVMIN	: Value of Y-var at VALMIN from RA plot
%   NUMXVAR : Number of X-var values in most recent RA computation
%   NUMYVAR : Number of Y-var values in most recent RA computation
%   BINW    : Bin-width of most recently computed histogram
%   NSPKMAX : Max. number of spikes from most recent PST (~)
%	SYNCCO	: Sync. Coeff. from most recent CH plot (~)
%	RAYSIG	: Rayleigh Coeff. from most recent CH plot (~)
%   PHASEMAX: Max. phase for most recent cycle histogram (~)
%   PHASEMIN: Min. phase for most recent cycle histogram (~)
%   REFRAC  : Refractory period from most recent ISI histogram (~)
%   SACDF   : Dominant frequency from most recent Autocorrelogram (~)
%   SACBW   : Bandwidth from most recent Autocorrrelogram (~)
%   SACPH   : Peakheight from most recent Autocorrelogram (~)
%   SACHHW  : Halfheight width from most recent Autocorrelogram (~)
%   XCDF    : Dominant frequency from most recent Crosscorrelogram (~)
%   XCBW    : Bandwidth from most recent Crosscorrrelogram (~)
%   XCPH    : Peakheight from most recent Crosscorrelogram (~)
%   XCHHW   : Halfheight width from most recent Crosscorrelogram (~)
%   DIFDF   : Dominant frequency from most recent Difcor (~)
%   DIFBW   : Bandwidth from most recent Difcor (~)
%   DIFPH   : Peakheight from most recent Difcor (~)
%   DIFHHW  : Halfheight width from most recent Difcor (~)
%   VSMMAX  : Maximum synchronicity from most recent Vector strength magnitude curve (~)
%   VSMBVAL : Best value of independent variable from most recent Vector strength magnitude curve (~)
%   VSMCO   : Cutoff synchronicity from most recent Vector strength magnitude curve (~)
%   VSMCOVAL: Cutoff value of independent variable from most recent Vector strength magnitude curve (~)
%   VSMRAYSIG: Table of rayleigh significance values of most recent Vector strength magnitude curve (~)
%   VSPCD   : Characterictic delay from most recent Vector strength phase curve (~)
%   VSPCP   : Characteristic phase from most recent Vector strength phase curve (~)
%   VSPRAYSIG: Table of rayleigh significance values of most recent Vector strength phase curve (~)
%   ISCV    : Mean Coeff. of Variation of Interspike intervals (~)
%   TRDAVG  : Average rate from most recent trial rate distribution (~)
%   TRDSTD  : Standard deviation on rate from most recent trial rate distribution (~)
%	XMIN	: X-minimum for most recent plot
%	XMAX	: X-maximum for most recent plot
%	YMIN	: Y-minimum for most recent plot
%	YMAX	: Y-maximum for most recent plot
%   XVLL    : Log or Linear increment for abcissa (~)
%   YVLL    : Log or Linear increment for ordinate (~)
%   AWLO    : Low analysis window from most recent comp. (millisecs)
%   AWHI    : High analysis window from most recent comp. (millisecs)
%
%   Most variables are returned as numeric (floating point) values except for 
%   those which are marked as "char string" above.
%   In cases where two tones were presented (i.e. a two DSS experiment) you can 
%   specify which DSS to get the values for by appending either #M (for Master 
%   DSS) or #S (for Slave DSS) to some of the above variable names. 
%   Only certain variables can be extended in this way. They are identified with 
%   a (*) after their description above.
%   This list of substitution variables can be extended by editing the file 
%   'RAPSUBSTVARLIST.M'. Further information can be found in this file.
%   (~) after a variable designates a changed name of the variable or a different
%   interpretation in this MATLAB implementation.
%
%   For further information on RAP (Response Area Data Analysis) see Users Guide on
%   http://www.neurophys.wisc.edu/comp/docs/rap/rep007.html
%

%B. Van de Sande 02-08-2005