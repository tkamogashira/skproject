echo on;
%------------------------------------------------------------------------------------------------------------------
%                                 psNDmonk SCRIPT for population analysis of NITD-data
%------------------------------------------------------------------------------------------------------------------
% created by PXJ 14-04-2006 based on popscripts created by Myles

% tag 1: identifies "primary" dataset of NTD responses for a given cell
% tag 2: identifies "secondary" sets of NTD responses for a given cell, i.e. sets that are not the "best"
% tag 3: identifies datasets that are NOT fit for best delay analysis (stereausis paper)
% if multiple NTD datasets (at different SPLs): sorted in ascending SPL ']

% NOTES:
% EvalNITD doesn't currently handle Rho=0 with many reps. Therefore all lines 
%       T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
% have been changed to 
%       T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
% and all 3 lines (in this combination only) 
%       T = EvalNITD(ds3, 'plot', 'y');
%       T.tag = [0 1];
%       D = [D;T]; pause; close; %Z 
% have been commented out. These changes can be undone using Find And Replace once the
% EvalNITD function has been updated.
%


D = struct([]);

%----------------------------------------------------------------------------
% 'M0312IC'
%----------------------------------------------------------------------------

DF = 'M0312IC';

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '10-1-NTD'; % CF 616 Hz

% SPL = 70  70   Rho = 1
dsIDp = '10-4-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'YRange', [0 120],'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1 -1 0
dsIDp = '10-5-NTD';
dsIDn = '10-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'YRange', [0 120], 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 65  65   Rho = -1
%dsIDp = '11-6-NTD'; % poor response

%--------------------------------------
% SPL = 65  65   Rho = -1
%dsIDp = '13-5-NTD'; % flat

% SPL = 65  65   Rho = -1
%dsIDp = '13-6-NTD'; % flat

% SPL = 75  75   Rho = 1 -1
%dsIDp = '13-8-NTD'; % flat
%dsIDn = '13-7-NTD';
%ds1 = dataset(DF, dsIDp);
%ds2 = dataset(DF, dsIDn);
%T = EvalNITD(ds1,ds2, 'plot', 'y');


%----------------------------------------------------------------------------
% 'M0313'
%----------------------------------------------------------------------------

% DF = 'M0313';
%--------------------------------------
% SPL = 60  60   Rho = 1
%dsIDp = '7-3-NTD'; % flat

%--------------------------------------
% SPL = 60  60   Rho = 1
%dsIDp = '10-7-NTD'; % flat


%----------------------------------------------------------------------------
% 'M0458'
%----------------------------------------------------------------------------

DF = 'M0458';
%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '1-5-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1
%dsIDp = '1-6-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1
%dsIDp = '1-7-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1
%dsIDp = '1-9-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1
%dsIDp = '1-10-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1
%dsIDp = '1-11-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1
%dsIDp = '1-12-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '2-2-NTD'; % trougher
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '3-10-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 89.9         89.9   Rho = 1
%dsIDp = '3-11-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 89.9         89.9   Rho = 1
%dsIDp = '3-12-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 89.9         89.9   Rho = 0
%dsIDp = '3-13-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 89.9         89.9   Rho = 1
%dsIDp = '4-10-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

%--------------------------------------
% SPL = 89.9         89.9   Rho = 1
%dsIDp = '8-2-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1
dsIDp = '8-3-NTD'; % poor response
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 30  30   Rho = 1
%dsIDp = '8-6-NTD'; % no response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1
%dsIDp = '8-9-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1
%dsIDp = '8-10-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '10-2-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '10-3-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% CHECK with Bram: mergeds does not work
% SPL = 35  35   Rho = 1 -1
%ds1 = dataset(DF,'10-7-NTD');
%ds2 = dataset(DF,'10-9-NTD'); % completion of ds 1 on lower side
%ds3 = dataset(DF,'10-10-NTD'); % completion of ds 1 on upper side
%ds1 = mergeds(ds2, -5000:200:-4000, ds1, -3800:200:4000, ds3, 4200:200:5000);
dsIDp = '10-7-NTD';
dsIDn = '10-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 35  35   Rho = 1
dsIDp = '11-2-NTD';
dsIDn = '11-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 55  80   Rho = 1
%dsIDp = '12-10-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

% SPL = 50  80   Rho = 1
%dsIDp = '12-11-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%----------------------------------------------------------------------------
% 'M0545'
%----------------------------------------------------------------------------

DF = 'M0545';
%--------------------------------------
% SPL = 50  50   Rho = 1
dsIDp = '3-2-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange', [0 80]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 40  40   Rho = 1
dsIDp = '3-18-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange', [0 100]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 40  40   Rho = 1
dsIDp = '4-1-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange', [0 140]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 40  40   Rho = 1  #Reps = 1
dsIDp = '7-2-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange', [0 80]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 40  40   Rho = 1 -1 0 
dsIDp = '7-3-NTD';
dsIDn = '7-6-NTD'; % redo of 7-4-NTD
dsIDu = '7-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange', [0 100]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 40  40   Rho = -1
dsIDn = '7-4-NTD'; % spike smaller toward end
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds2, 'plot', 'y', 'YRange', [0 100]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 40  40   Rho = 0
dsIDu = '7-16-NTD'; % like 7-5-NTD but 5/6 s, for revcor

%--------------------------------------
% SPL = 40  40   Rho = 0
dsIDu = '8-2-NTD'; % lost it

%--------------------------------------
% SPL = 40  40   Rho = 0
dsIDu = '9-2-NTD'; % rho = 0 by error

%--------------------------------------
% SPL = 40  40   Rho = 0
dsIDu = '10-2-NTD-Q'; % lost it

%--------------------------------------
% SPL = 40  40   Rho = 0
dsIDu = '11-2-NTD'; % rho = 0 by error
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds3, 'plot', 'y');
%T.tag = [0 1];
%D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 0
dsIDu = '11-3-NTD-Q'; % rho = 0 by error
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds3, 'plot', 'y');
%T.tag = [0 1];
%D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '11-4-NTD';
dsIDn = '11-5-NTD';
dsIDu = '11-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y','YRange', [0 140]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 0
dsIDu = '11-28-NTD'; % for revcor
ds3 = dataset(DF, dsIDu);

%--------------------------------------
% SPL = 70  70   Rho = 1 0
dsIDp = '12-4-NTD'; % barely any ITD-sensitivity
dsIDu = '12-3-NTD';
ds1 = dataset(DF, dsIDp);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds3, 'plot', 'y','YRange', [0 50]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '14-2-NTD'; % barely responds

% SPL = 80  80   Rho = 1
%dsIDp = '14-3-NTD'; % barely responds

% SPL = 50  50   Rho = 1
%dsIDp = '14-4-NTD'; % barely responds

% SPL = 74  74   Rho = 1
dsIDp = '14-28-NTD'; % Nrep = 1
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y'); 
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 74  74   Rho = 1 -1 0
dsIDp = '14-29-NTD';
dsIDn = '14-30-NTD';
dsIDu = '14-31-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); 
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 74  74   Rho = 1
dsIDp = '14-33-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y'); 
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '15-4-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 0
%dsIDu = '15-5-NTD-revcor'; % for revcor
%ds3 = dataset(DF, dsIDu);

% SPL = 30  30   Rho = 1
%dsIDp = '15-47-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

% SPL = 40  40   Rho = 1
%dsIDp = '15-48-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 60  60   Rho = 1
%dsIDp = '17-1-NTD-Q'; % barely responds
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 60  60   Rho = 1
%dsIDp = '18-3-NTD-q'; % no response
%ds1 = dataset(DF, dsIDp);

% SPL = 80  80   Rho = 1
%dsIDp = '18-4-NTD-q'; % barely responds
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 60  60   Rho = 1
%dsIDp = '19-2-NTD-q'; % poor response
%ds1 = dataset(DF, dsIDp);

% SPL = 60  60   Rho = 1
%dsIDp = '19-3-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 60  60   Rho = 1
%dsIDp = '21-2-NTD-Q'; % incomplete
%ds1 = dataset(DF, dsIDp);

% SPL = 60  60   Rho = 1
%dsIDp = '21-3-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
dsIDp = '21-4-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '21-5-NTD';
dsIDn = '21-7-NTD';
%dsIDu = '21-6-NTD'; % for revcor
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
%ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); 
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '21-8-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1 -1
dsIDp = '22-2-NTD';
dsIDn = '22-11-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1
%dsIDp = '22-13-NTD'; % only 3 reps
%ds1 = dataset(DF, dsIDp); % 

% SPL = 80  80   Rho = 1 -1 0
dsIDp = '22-14-NTD';
dsIDn = '22-15-NTD';
dsIDu = '22-16-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); 
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 0
%dsIDu = '23-3-NTD-Q'; % flat
%ds3 = dataset(DF, dsIDu);

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '25-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '25-5-NTD';
dsIDn = '25-4-NTD';
dsIDu = '25-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); 
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 85  85   Rho = 1 -1 0
dsIDp = '25-14-NTD';
dsIDn = '25-16-NTD';
dsIDu = '25-17-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y','YRange', [0 80]); 
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '25-60-NTD'; % very low response
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 60  60   Rho = 1
%dsIDp = '28-2-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 60  60   Rho = 1
%dsIDp = '32-3-NTD'; % flat

% SPL = 70  70   Rho = 1
%dsIDp = '32-4-NTD'; % flat

% SPL = 80  80   Rho = 1
dsIDp = '32-5-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1
dsIDp = '32-6-NTD'; % noisy response
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1
dsIDp = '32-7-NTD'; % rather weak ITD-sensitivity
dsIDn = '32-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1, ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '34-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '35-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '35-3-NTD'; % poor response modulation 
dsIDn = '35-4-NTD';
dsIDu = '35-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '35-6-NTD'; % poor response modulation 
dsIDn = '35-7-NTD';
dsIDu = '35-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); 
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '35-24-NTD';
dsIDn = '35-23-NTD';
dsIDu = '35-59-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1
dsIDp = '35-60-NTD'; % nice response
dsIDn = '35-61-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1 -1 0
dsIDp = '35-62-NTD'; % flat
dsIDn = '35-63-NTD';
dsIDu = '35-64-NTD'; % for revcor (only ITD = 0)
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
%ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1
dsIDp = '35-66-NTD'; % flat
dsIDn = '35-67-NTD';
dsIDu = '35-65-NTD'; % for revcor
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = -1
%dsIDn = '35-68-NTD'; % for revcor
%ds2 = dataset(DF, dsIDn);

%----------------------------------------------------------------------------
% 'M0545B'
%----------------------------------------------------------------------------
DF = 'M0545B';


%--------------------------------------
% SPL = 80  80   Rho = 1 -1 0
dsIDp = '35-126-NTD';
dsIDn = '35-127-NTD';
dsIDu = '35-128-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1 -1 0
dsIDp = '36-6-NTD';
dsIDn = '36-8-NTD';
dsIDu = '36-7-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '36-21-NTD';
dsIDn = '36-22-NTD';
dsIDu = '36-23-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '37-2-NTD'; 
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1 0
dsIDp = '37-5-NTD';
dsIDn = '37-6-NTD';
dsIDu = '37-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 0
%dsIDp = '37-70-NTD'; % only 1 ITD
%dsIDu = '37-71-NTD'; % only 1 ITD

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '38-2-NTD'; % only 1 ITD
%ds1 = dataset(DF, dsIDp);

% SPL = 80  80   Rho = 1
%dsIDp = '38-3-NTD'; % Nrep = 1
%ds1 = dataset(DF, dsIDp);

% SPL = 80  80   Rho = 1 -1 0
dsIDp = '38-6-NTD';
dsIDn = '38-7-NTD';
dsIDu = '38-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1 -1 0
dsIDp = '39-2-NTD'; % rather low response rates
dsIDn = '39-3-NTD';
dsIDu = '39-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 60  60   Rho = 1
dsIDp = '41-4-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1 -1 0
dsIDp = '41-8-NTD';
dsIDn = '41-10-NTD';
dsIDu = '41-9-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y','YRange',[0 150]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 40  40   Rho = 1
dsIDp = '41-12-NTD'; % flat
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1 -1
dsIDp = '41-13-NTD';
dsIDn = '41-14-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '41-15-NTD';
dsIDn = '41-16-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y','YRange',[0 130]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '42-2-NTD-Q'; % not ITD-sensitive
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '44-1-NTD'; % not ITD-sensitive
%ds1 = dataset(DF, dsIDp);

% SPL = 80  80   Rho = 1
%dsIDp = '44-2-NTD';
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '45-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 80  80   Rho = 1
dsIDp = '46-2-NTD-Q'; % noisy
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y','YRange',[0 150]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1
dsIDp = '47-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y','YRange',[0 130]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1
dsIDp = '47-3-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y','YRange',[0 130]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1 0
dsIDp = '47-4-NTD';
dsIDn = '47-5-NTD';
dsIDu = '47-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 130]); 
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '47-7-NTD';
dsIDn = '47-8-NTD';
dsIDu = '47-9-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); 
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1 -1
dsIDp = '47-10-NTD';
dsIDn = '47-11-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1
dsIDp = '47-12-NTD';
dsIDn = '47-13-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = -1
%dsIDp = '48-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 130]);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '49-2-NTD-Q'; % noisy
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1
%dsIDp = '49-8-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);

% SPL = 50  50   Rho = 1
%dsIDp = '49-9-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);

% SPL = 60  80   Rho = 1
%dsIDp = '49-10-NTD'; %flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '50-2-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

% SPL = 80  80   Rho = 1
%dsIDp = '50-3-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '51-1-NTD'; % flat
%ds1 = dataset(DF, dsIDp);


%----------------------------------------------------------------------------
% 'M0545C'
%----------------------------------------------------------------------------
DF = 'M0545C';

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '53-1-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '53-2-NTD'; % weak ITD-sensitivity
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1
%dsIDp = '53-3-NTD'; % weak ITD-sensitivity
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 80  80   Rho = 1
%dsIDp = '53-4-NTD'; %noisy
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '54-1-NTD'; % unfinished
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 80  80   Rho = 1
%dsIDp = '54-2-NTD'; % weak ITD-sensitivity
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 80  80   Rho = 1
%dsIDp = '54-3-NTD'; % weak ITD-sensitivity
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1
%dsIDp = '54-4-NTD'; % weak ITD-sensitivity
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '54-5-NTD'; % Quick: NOTE THAT THIS IS CELL 55
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 80  80   Rho = 1 -1
dsIDp = '55-1-NTD'; % weak peak, envelope cell
dsIDn = '55-2-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '56-2-NTD-Q'; % looks like envelope cell, lost it
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '58-3-NTD';
ds1 = dataset(DF, dsIDp); % trougher
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '58-4-NTD';
ds1 = dataset(DF, dsIDp); % trougher
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
%dsIDp = '58-5-NTD'; % don't know what to make of this
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '59-2-NTD'; % weak ITD-sensitivity
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '59-3-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1
dsIDp = '59-4-NTD';
dsIDn = '59-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1 -1 0
dsIDp = '60-4-NTD';
dsIDn = '60-3-NTD-Q';
dsIDu = '60-5-NTD'; % for revcor
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 150]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '60-8-NTD';
dsIDn = '60-9-NTD';
dsIDu = '60-10-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 150]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 0
%dsIDu = '60-11-NTD-LE'; % monaural ipsi
%ds3 = dataset(DF, dsIDu);

% SPL = 90  90   Rho = 0
%dsIDu = '60-12-NTD'; % monaural contra
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '61-3-NTD'; % unfinished
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '61-4-NTD';
dsIDn = '61-6-NTD';
dsIDu = '61-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '61-8-NTD';
dsIDn = '61-9-NTD';
dsIDu = '61-10-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 100]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1 -1 0
dsIDp = '61-11-NTD';
dsIDn = '61-13-NTD';
dsIDu = '61-12-NTD'; % cell often "irritated"
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1
dsIDp = '62-2-NTD-Q'; % low response rate
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1
dsIDp = '62-3-NTD';
dsIDn = '62-4-NTD';
dsIDu = '62-5-NTD'; % for revcor
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '62-6-NTD';
dsIDn = '62-7-NTD';
dsIDu = '62-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1
dsIDp = '62-9-NTD'; % low response rate
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '62-10-NTD';
dsIDn = '62-11-NTD';
dsIDu = '62-12-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 0
%dsIDu = '62-16-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

% SPL = 80  80   Rho = 0
%dsIDu = '62-17-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

% SPL = 90  90   Rho = 0
%dsIDu = '62-18-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

% SPL = 90  90   Rho = 0
%dsIDu = '62-20-NTD-Q'; % for revcor
%ds3 = dataset(DF, dsIDu);

%--------------------------------------
% SPL = 90  90   Rho = 0
%dsIDu = '63-2-NTD-Q'; % Rho 0 by error
%ds3 = dataset(DF, dsIDu);

% SPL = 90  90   Rho = 0
%dsIDu = '63-4-NTD'; % Rho 0 by error
%ds3 = dataset(DF, dsIDu);

%--------------------------------------
% SPL = 90  90   Rho = 0
%dsIDu = '64-1-NTD-Q';  % Rho 0 by error
%ds3 = dataset(DF, dsIDu);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '65-3-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds3, 'plot', 'y');

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '65-4-NTD';
dsIDn = '65-5-NTD';
dsIDu = '65-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 80]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '65-7-NTD';
dsIDn = '65-8-NTD';
dsIDu = '65-9-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 110]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1
dsIDp = '65-10-NTD'; % flat
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 0
%dsIDu = '65-15-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '66-2-NTD-Q'; % no response
%ds1 = dataset(DF, dsIDp);

% SPL = 95  95   Rho = 1
%dsIDp = '66-3-NTD'; % no response
%ds1 = dataset(DF, dsIDp);

% SPL = 95  95   Rho = -1
%dsIDn = '66-5-NTD-Q'; % no response
%ds2 = dataset(DF, dsIDn);

% SPL = 95  95   Rho = -1
%dsIDn = '66-6-NTD'; % no response
%ds2 = dataset(DF, dsIDn);

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '67-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '67-3-NTD';
dsIDn = '67-4-NTD';
dsIDu = '67-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '67-7-NTD';
dsIDn = '67-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '68-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1
%dsIDp = '68-7-NTD'; % low rate
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 60  60   Rho = 1
%dsIDp = '68-8-NTD'; % noisy
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '70-2-NTD-Q'; % barely responds
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 95  95   Rho = -1
%dsIDn = '70-4-NTD-Q'; % barely responds
%ds2 = dataset(DF, dsIDn);
%T = EvalNITD(ds2, 'plot', 'y');

%----------------------------------------------------------------------------
% 'M0545D'
%----------------------------------------------------------------------------
DF = 'M0545D';

%--------------------------------------
% SPL = 70  70   Rho = -1
%dsIDn = '71-3-NTD'; % flat
%ds2 = dataset(DF, dsIDn);
%T = EvalNITD(ds2, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '72-3-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '72-6-NTD';
dsIDn = '72-8-NTD';
dsIDu = '72-4-NTD'; % for revcor
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 100]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = -1
dsIDn = '72-5-NTD'; % curve more noisy than 72-8
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds2, 'plot', 'y', 'YRange',[0 100]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = -1
%dsIDn = '72-9-NTD-LE';  % monaural
%ds2 = dataset(DF, dsIDn);

% SPL = 70  70   Rho = -1
%dsIDn = '72-10-NTD-RE'; % monaural
%ds2 = dataset(DF, dsIDn);

% SPL = 90  90   Rho = 0
%dsIDu = '72-14-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '72-15-NTD';
dsIDn = '72-16-NTD';
dsIDu = '72-13-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 100]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '73-2-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '73-5-NTD';
dsIDn = '73-4-NTD';
dsIDu = '73-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
%dsIDp = '73-7-NTD-LE'; % monaural
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '73-8-NTD-RE'; % monaural
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '74-2-NTD';
%ds1 = dataset(DF, dsIDp); % unfinished
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1
dsIDp = '74-3-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '74-6-NTD';
dsIDn = '74-5-NTD';
dsIDu = '74-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
%dsIDp = '74-8-NTD-LE'; % monaural
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '74-9-NTD-RE'; % monaural
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 0
%dsIDp = '74-10-NTD'; % more revcor data, with different seeds
%ds1 = dataset(DF, dsIDp);
%dsIDu = '74-11-NTD';
%ds3 = dataset(DF, dsIDu);
%dsIDu = '74-12-NTD';
%ds3 = dataset(DF, dsIDu);
%dsIDu = '74-13-NTD';
%ds3 = dataset(DF, dsIDu);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '75-2-NTD'; % error
%dsIDp = '75-3-NTD'; % noisy

% SPL = 70  70   Rho = 0
dsIDu = '75-5-NTD';
ds3 = dataset(DF, dsIDu);
%T = EvalNITD(ds3, 'plot', 'y');

% SPL = 90  90   Rho = 1 -1
%dsIDp = '75-6-NTD'; % flat and noisy
%dsIDn = '75-7-NTD';
%ds1 = dataset(DF, dsIDp);
%ds2 = dataset(DF, dsIDn);
%T = EvalNITD(ds1,ds2, 'plot', 'y');

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '75-9-NTD';
dsIDn = '75-8-NTD';
dsIDu = '75-10-NTD'; % only 1 ITD
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1 -1 0
dsIDp = '76-2-NTD';
dsIDn = '76-4-NTD';
dsIDu = '76-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 80]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = -1
%dsIDn = '76-6-NTD-RE'; % monaural
% SPL = 70  70   Rho = -1
%dsIDn = '76-7-NTD-LE'; % monaural
%ds2 = dataset(DF, dsIDn);

%--------------------------------------
% SPL = 70  70   Rho = 1 -1
dsIDp = '77-2-NTD';
dsIDn = '77-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = -1
%dsIDn = '77-5-NTD-LE'; % monaural (N = 1)
% SPL = 70  70   Rho = -1
%dsIDn = '77-6-NTD'; % monaural
% SPL = 70  70   Rho = -1
%dsIDn = '77-7-NTD-RE'; % monaural
%ds2 = dataset(DF, dsIDn);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '78-1-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '79-2-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '79-3-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 110]);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '80-2-NTD-Q'; % no response
%ds1 = dataset(DF, dsIDp);

% SPL = 95  95   Rho = 1
%dsIDp = '80-6-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

% SPL = 95  95   Rho = 1
%dsIDp = '80-7-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '81-3-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1 -1
%dsIDp = '81-4-NTD'; % flat
%dsIDn = '81-5-NTD';
%ds1 = dataset(DF, dsIDp);
%ds2 = dataset(DF, dsIDn);

%--------------------------------------
% SPL = 90  90   Rho = -1
%dsIDn = '82-1-NTD-Q'; % flat
%ds2 = dataset(DF, dsIDn);
%T = EvalNITD(ds2, 'plot', 'y', 'YRange',[0 110]);

% SPL = 90  90   Rho = -1
%dsIDn = '82-2-NTD'; % noisy
%ds2 = dataset(DF, dsIDn);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '83-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1
%dsIDp = '83-3-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '84-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1
%dsIDp = '84-3-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '85-10-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '86-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1
%dsIDp = '86-3-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '86-5-NTD';
dsIDn = '86-6-NTD';
dsIDu = '86-7-NTD';
ds1 = dataset(DF, dsIDp); % low response rate
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu); % for revcor
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '87-1-NTD'; % noisy
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '88-2-NTD-Q'; % weak ITD-sensitivity
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1
%dsIDp = '88-3-NTD'; % noisy
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '89-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '89-3-NTD';
dsIDn = '89-4-NTD';
dsIDu = '89-7-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '89-8-NTD'; % flat
dsIDn = '89-9-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '89-10-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 
dsIDp = '89-11-NTD';
dsIDn = '89-12-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 100 100   Rho = 1 -1
dsIDp = '89-17-NTD';
dsIDn = '89-18-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 100]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 100 100   Rho = 1
%dsIDp = '89-24-NTD'; % monaural left
%ds1 = dataset(DF, dsIDp);
% SPL = 100 100   Rho = 1
%dsIDp = '89-25-NTD'; % monaural right
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '91-3-NTD'; % incomplete
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '92-2-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '94-2-NTD'; % incomplete
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 1 -1 0
dsIDp = '97-2-NTD';
dsIDn = '97-4-NTD';
dsIDu = '97-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1 -1
dsIDp = '98-2-NTD';
dsIDn = '98-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 120]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = -1
%dsIDn = '98-5-NTD-LE'; % monaural ipsi
%ds2 = dataset(DF, dsIDn);
% SPL = 70  70   Rho = -1
%dsIDn = '98-6-NTD-RE'; % monaural contra
%ds2 = dataset(DF, dsIDn);

% SPL = 90  90   Rho = 1
dsIDp = '98-7-NTD';
dsIDn = '98-8-NTD';
dsIDu = '98-9-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 120]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 0
%dsIDu = '98-10-NTD-LE'; % monaural 
%ds3 = dataset(DF, dsIDu);

% SPL = 50  50   Rho = 1
%dsIDp = '98-17-NTD'; % error: monaural right
%ds1 = dataset(DF, dsIDp);

% SPL = 50  50   Rho = 1 -1
dsIDp = '98-18-NTD';
dsIDn = '98-27-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 30  30   Rho = 1 -1
dsIDp = '98-19-NTD';
dsIDn = '98-30-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 30  30   Rho = -1
%dsIDn = '98-28-NTD'; % missing spikes
%ds2 = dataset(DF, dsIDn);
%T = EvalNITD(ds2, 'plot', 'y');

% SPL = 60  80   Rho = 1
dsIDp = '98-31-NTD'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  60   Rho = 1
dsIDp = '98-32-NTD'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '98-33-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 50  90   Rho = 1
dsIDp = '98-34-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 90  50   Rho = 1
dsIDp = '98-35-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '99-2-NTD'; % unfinished
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
dsIDp = '99-3-NTD'; % quick
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '99-4-NTD'; % quick
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '99-5-NTD';
dsIDn = '99-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = -1
%dsIDn = '99-7-NTD-LE'; % monaural left
%ds2 = dataset(DF, dsIDn);

% SPL = 70  70   Rho = -1
%dsIDn = '99-8-NTD-RE'; % monaural right
%ds2 = dataset(DF, dsIDn);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '100-1-NTD'; % quick, flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1
%dsIDp = '100-2-NTD'; % quick, noisy
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1 -1
dsIDp = '100-3-NTD'; % noisy, poor response
dsIDn = '100-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '100-7-NTD'; % noisy, poor response
dsIDn = '100-9-NTD';
dsIDu = '100-16-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = -1
%dsIDn = '100-8-NTD'; % unfinished, spike lost halfway
%ds2 = dataset(DF, dsIDn);
%T = EvalNITD(ds2, 'plot', 'y');

% SPL = 90  90   Rho = 1 -1
dsIDp = '100-11-NTD'; % poor response
dsIDn = '100-10-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1
dsIDp = '100-12-NTD'; % weakly modulated
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 30  30   Rho = 1
dsIDp = '100-13-NTD'; % flat
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
%dsIDp = '100-14-NTD'; % left ear
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '100-15-NTD-RE'; right ear
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 0
dsIDu = '101-2-NTD';
ds3 = dataset(DF, dsIDu);
%T = EvalNITD(ds3, 'plot', 'y');
%T.tag = [0 1];
%D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '101-3-NTD'; % very poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '102-4-NTD'; % flat, celle with enormous rebound
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '104-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '105-2-NTD-Q'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '105-3-NTD';
dsIDn = '105-4-NTD';
dsIDu = '105-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1 0
dsIDp = '105-6-NTD'; % barely responds
dsIDn = '105-7-NTD';
dsIDu = '105-20-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '105-17-NTD';
dsIDn = '105-18-NTD';
dsIDu = '105-21-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 0
%dsIDu = '105-19-NTD'; %for revcor
%ds3 = dataset(DF, dsIDu);

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '106-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 100]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '106-3-NTD';
dsIDn = '106-4-NTD';
dsIDu = '106-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '106-7-NTD'; % low response rate
dsIDn = '106-8-NTD';
dsIDu = '106-9-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1
dsIDp = '106-10-NTD'; % little or no response
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1 0
dsIDp = '106-12-NTD'; % low response rate
dsIDn = '106-13-NTD';
dsIDu = '106-11-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1
dsIDp = '107-1-NTD-Q'; % quick, low rate
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1 0
dsIDp = '107-2-NTD';
dsIDn = '107-3-NTD';
dsIDu = '107-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '107-6-NTD';
dsIDn = '107-7-NTD';
dsIDu = '107-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '108-1-NTD'; % noisy
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 150]);

%--------------------------------------
% SPL = 80  80   Rho = 1
dsIDp = '109-1-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 100]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1 0
dsIDp = '109-2-NTD';
dsIDn = '109-3-NTD';
dsIDu = '109-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 100]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 0
dsIDu = '110-2-NTD-Q'; % uncorrelated
ds3 = dataset(DF, dsIDu);
%T = EvalNITD(ds3, 'plot', 'y');
%T.tag = [0 1];
%D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '110-3-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '110-4-NTD';
dsIDn = '110-7-NTD';
dsIDu = '110-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 60  80   Rho = 1
dsIDp = '110-8-NTD-6080'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '110-9-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 60  80   Rho = 1
dsIDp = '110-11-NTD-6080'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  60   Rho = 1
dsIDp = '110-12-NTD-8060'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  90   Rho = 1
dsIDp = '110-13-NTD-5090'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  50   Rho = 1
dsIDp = '110-14-NTD-9050'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 60  70   Rho = 1
dsIDp = '110-15-NTD-6070'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  70   Rho = 1
dsIDp = '110-16-NTD-8070'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  60   Rho = 1
dsIDp = '110-17-NTD-7060'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  80   Rho = 1
dsIDp = '110-18-NTD-7080'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '112-3-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 120]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '112-4-NTD';
dsIDn = '112-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 120]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 60  80   Rho = 1
dsIDp = '112-6-NTD-6080'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  60   Rho = 1
dsIDp = '112-7-NTD-8060'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '112-8-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 120]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '112-13-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 120]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1
dsIDp = '112-18-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
%dsIDp = '112-19-NTD-LE'; % monaural
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '112-20-NTD-RE'; % monaural
%ds1 = dataset(DF, dsIDp);


%----------------------------------------------------------------------------
% 'M0545E'
%----------------------------------------------------------------------------
DF = 'M0545E';


%--------------------------------------
% SPL = 70  70   Rho = 0
%dsIDu = '112-31-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

% SPL = 70  70   Rho = 0
%dsIDu = '112-32-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

% SPL = 70  70   Rho = 0
%dsIDu = '112-33-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

% SPL = 70  70   Rho = 0
%dsIDu = '112-34-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

% SPL = 70  70   Rho = 0
%dsIDu = '112-35-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '112-37-NTD';
dsIDn = '112-38-NTD';
dsIDu = '112-36-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 100]); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = -1
dsIDn = '112-39-NTD';
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '113-3-NTD-Q'; % rather flat
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 120]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '113-4-NTD'; % noise? undersampled?
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 120]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = -1
%dsIDn = '113-6-NTD'; % flat
%ds2 = dataset(DF, dsIDn);
%T = EvalNITD(ds2, 'plot', 'y', 'YRange',[0 120]);

%--------------------------------------
% SPL = 80  80   Rho = -1
dsIDn = '114-1-NTD'; % quick
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1 0
dsIDp = '114-2-NTD';
dsIDn = '114-3-NTD';
dsIDu = '114-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1 -1
dsIDp = '114-12-NTD'; % poor response
dsIDn = '114-13-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1
dsIDp = '114-15-NTD';
dsIDn = '114-14-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 120]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '115-3-NTD-Q'; % very noisy
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '116-1-NTD'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '117-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1
%dsIDp = '117-3-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '118-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '119-4-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '120-2-NTD'; % barely responds
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1
dsIDp = '120-3-NTD'; % poor response
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

if 0
% SPL = 90  90   Rho = 1 -1 0
dsIDp = '120-4-NTD';
dsIDn = '120-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 
end

% SPL = 100 100   Rho = 0
%dsIDu = '120-7-NTD'; % for revcor, 1 s duratoin
%ds3 = dataset(DF, dsIDu);

% SPL = 100 100   Rho = 0
%dsIDu = '120-8-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

%--------------------------------------
% THIS IS NEW CELL 121 : CHECK USER DATA
% SPL = 90  90   Rho = 1
dsIDp = '120-10-NTD';
dsIDn = '121-7-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%dsIDu = '120-11-NTD'; % for revcor
%ds1 = dataset(DF, dsIDu);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 0
%dsIDu = '120-12-NTD'; % monaural left
%ds3 = dataset(DF, dsIDu);

% SPL = 90  90   Rho = 0
%dsIDu = '121-5-NTD-RE'; % monaural right
%ds3 = dataset(DF, dsIDu);
%dsIDu = '121-6-NTD-RE'; % monaural right
%ds3 = dataset(DF, dsIDu);

% SPL = 90  90   Rho = -1 0
%dsIDu = '121-8-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

%--------------------------------------
% SPL = 90  90   Rho = 0
dsIDu = '122-2-NTD'; % error: rho = 0
ds3 = dataset(DF, dsIDu);
%T = EvalNITD(ds3, 'plot', 'y');

% SPL = 90  90   Rho = 1
dsIDp = '122-3-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '122-4-NTD';
dsIDn = '122-5-NTD';
dsIDu = '122-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '123-1-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '123-2-NTD';
dsIDn = '123-3-NTD';
dsIDu = '123-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 0
%dsIDu = '123-5-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);
% SPL = 90  90   Rho = 0
%dsIDu = '123-6-NTD'; % different seed
%ds3 = dataset(DF, dsIDu);

% SPL = 70  70   Rho = 1 -1
dsIDp = '123-9-NTD-70';
dsIDn = '123-10-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
%dsIDp = '123-11-NTD-LE'; % monaural
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '123-12-NTD-RE'; % monaural
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '124-2-NTD-Q'; % all flat
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '124-3-NTD';
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '124-4-NTD';
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1
%dsIDp = '124-5-NTD';
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '125-2-NTD'; % low rate
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '127-2-NTD'; % noisy
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '127-3-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '127-4-NTD';
dsIDn = '127-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = -1
%dsIDn = '127-7-NTD-LE'; % monaural left
%ds2 = dataset(DF, dsIDn);

% SPL = 70  70   Rho = -1
%dsIDn = '127-8-NTD-RE'; % monaural right
%ds2 = dataset(DF, dsIDn);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '128-2-NTD'; % does not respond to noise
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '128-3-NTD';
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '128-4-NTD';
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1
%dsIDp = '128-5-NTD';
%ds1 = dataset(DF, dsIDp);

% SPL = 50  50   Rho = 1
%dsIDp = '128-6-NTD';
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 0
%dsIDu = '130-1-NTD'; % flat
%ds3 = dataset(DF, dsIDu);

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '132-2-NTD-Q'; % trougher?
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '133-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 
%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '134-2-NTD-Q'; % little ITD-sensitivity
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '135-1-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1
%dsIDp = '135-2-NTD'; % noisy
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1 -1
dsIDp = '135-3-NTD'; % weak ITD-sensitivity
dsIDn = '135-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 120]); 
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '136-1-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 120]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '136-2-NTD';
dsIDn = '136-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 120]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1
%dsIDp = '136-5-NTD'; % very noisy
%dsIDn = '136-6-NTD';
%ds1 = dataset(DF, dsIDp);
%ds2 = dataset(DF, dsIDn);
%T = EvalNITD(ds1,ds2, 'plot', 'y');

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '137-1-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 120]);


%----------------------------------------------------------------------------
% 'M0545F'
%----------------------------------------------------------------------------
DF = 'M0545F';

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '2-1-NTD'; % this is cell 139, flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1
%dsIDp = '2-2-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 60  60   Rho = 1
dsIDp = '140-2-NTD'; % flat
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1
dsIDp = '140-3-NTD'; % little ITD-sensitivity
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1
dsIDp = '140-4-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '140-5-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '140-6-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = -1
dsIDp = '140-8-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1 -1
dsIDp = '141-3-NTD';
dsIDn = '141-2-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '141-4-NTD';
dsIDn = '141-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '142-1-NTD'; % poor ITD-selectivity
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '142-2-NTD'; % poor ITD-selectivity
dsIDn = '142-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '142-4-NTD'; % poor ITD-selectivity
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '143-1-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '144-1-NTD-Q'; 
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '144-2-NTD';
dsIDn = '144-3-NTD';
dsIDu = '144-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 0
%dsIDu = '144-7-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '144-11-NTD';
dsIDn = '144-12-NTD';
dsIDu = '144-13-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 
dsIDp = '144-17-NTD'; % 1500-8000 Hz bandwidth
dsIDn = '144-18-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '144-20-NTD'; % 50-1500 Hz bandwidth
dsIDn = '144-19-NTD';
dsIDu = '144-24-NTD-revcor';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '145-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 200]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '148-3-NTD-Q';
dsIDn = '148-4-NTD-Q';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '148-6-NTD'; % envelope sensitivity
dsIDn = '148-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y'); 
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1
dsIDp = '148-7-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y'); 
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '148-8-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y'); 
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '148-10-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1
dsIDp = '148-11-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y'); 
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
%dsIDp = '148-12-NTD-LE'; % monaural left, N = 5
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1
%dsIDp = '148-13-NTD-LE'; % monaural left, N = 20
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1
%dsIDp = '148-14-NTD-RE'; % monaural right, N = 20
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1
%dsIDp = '148-15-NTD'; % 2-3 kHz - error: monaural right
%ds1 = dataset(DF, dsIDp);

% SPL = 90  90   Rho = 1
dsIDp = '148-16-NTD'; % 2-3 kHz
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1
dsIDp = '148-17-NTD'; % 2-3 kHz
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1 0
dsIDp = '148-22-NTD';
dsIDn = '148-23-NTD';
dsIDu = '148-45-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '149-10-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp); 
%T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 200]);

% SPL = 80  80   Rho = 1
%dsIDp = '149-11-NTD';
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 80  80   Rho = 1
dsIDp = '151-4-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '152-4-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');
%T.tag = [0 1];
%D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1
dsIDp = '152-5-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1 -1 0
dsIDp = '152-6-NTD';
dsIDn = '152-7-NTD';
dsIDu = '152-9-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 0
%dsIDu = '152-8-NTD'; % for revcor
%ds3 = dataset(DF, dsIDu);

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '153-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '154-3-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1
%dsIDp = '154-4-NTD';
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '155-1-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '156-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1 -1
dsIDp = '156-3-NTD'; % very weak ITD-sensitivity
dsIDn = '156-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1
dsIDp = '157-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1
dsIDp = '157-3-NTD';
dsIDn = '157-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '158-1-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 80  80   Rho = 1
%dsIDp = '159-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 200]);

% SPL = 80  80   Rho = 1
%dsIDp = '159-3-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 80  80   Rho = 1
%dsIDp = '159-4-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '160-1-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1 -1
dsIDp = '160-2-NTD'; % weak response
dsIDn = '160-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '161-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1
%dsIDp = '161-5-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 50  50   Rho = 1
%dsIDp = '161-11-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '162-1-NTD-Q'; % noisy
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1 -1
dsIDp = '162-2-NTD'; % very weak ITD-sensitivy
dsIDn = '162-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1
dsIDp = '162-12-NTD'; % very weak ITD-sensitivy
dsIDn = '162-11-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '163-2-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1
%dsIDp = '163-3-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 50  50   Rho = 1
%dsIDp = '163-5-NTD-50';
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 90  90   Rho = 1 -1
%dsIDp = '163-6-NTD-90'; % barely responds
%dsIDn = '163-7-NTD';
%ds1 = dataset(DF, dsIDp);
%ds2 = dataset(DF, dsIDn);
%T = EvalNITD(ds1,ds2, 'plot', 'y');

% SPL = 70  70   Rho = 1
%dsIDp = '165-3-NTD';
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1 -1 0
dsIDp = '165-5-NTD';
dsIDn = '165-4-NTD';
dsIDu = '165-6-NTD'; % for revcor
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 0
%dsIDu = '165-7-NTD-LE'; % monaural left
%ds3 = dataset(DF, dsIDu);

% SPL = 70  70   Rho = 0
%dsIDu = '165-8-NTD-RE'; % monaural right
%ds3 = dataset(DF, dsIDu);

% SPL = 70  70   Rho = 0
%dsIDu = '165-47-NTD'; % error (monaural)
%ds3 = dataset(DF, dsIDu);

% SPL = 70  70   Rho = 0
%dsIDu = '165-48-NTD'; % for revcor, different seed
%ds3 = dataset(DF, dsIDu);

%dsIDu = '165-49-NTD'; % rho = 0, accidentally

% SPL = 90  90   Rho = 1 0
dsIDp = '165-50-NTD';
dsIDu = '165-49-NTD';
ds1 = dataset(DF, dsIDp);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1
dsIDp = '165-51-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1 -1
dsIDp = '165-134-NTD';
dsIDn = '165-135-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 40  40   Rho = 1
%dsIDp = '165-136-NTD'; % monaural
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 75  75   Rho = 1
%dsIDp = '166-2-NTD-Q'; % low rate
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 75  75   Rho = 1 -1
dsIDp = '166-3-NTD';
dsIDn = '166-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '166-6-NTD'; % weak ITD-sensitivity
dsIDn = '166-5-NTD';
dsIDu = '166-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1 -1
dsIDp = '166-9-NTD'; % very low response rate
dsIDn = '166-10-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 75  75   Rho = 1
%dsIDp = '167-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 75  75   Rho = 1
%dsIDp = '168-2-NTD-Q'; % low rate
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 75  75   Rho = 1 -1
%dsIDp = '168-3-NTD'; % low ITD-sensitivity
%dsIDn = '168-4-NTD';
%ds1 = dataset(DF, dsIDp);
%ds2 = dataset(DF, dsIDn);
%T = EvalNITD(ds1,ds2, 'plot', 'y');
%T.tag = [0 1];
%D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1 0
dsIDp = '168-6-NTD'; % low ITD-sensitivity
dsIDn = '168-7-NTD';
dsIDu = '168-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y'); %T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '169-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 75  75   Rho = 1
%dsIDp = '170-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 75  75   Rho = 1
%dsIDp = '171-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 75  75   Rho = 1
%dsIDp = '173-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 90  90   Rho = 1
%dsIDp = '174-1-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 200]);

% SPL = 75  75   Rho = 1
%dsIDp = '174-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 200]);

%--------------------------------------
% SPL = 75  75   Rho = 1
%dsIDp = '175-1-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%save(mfilename, 'D');
%echo off;


%----------------------------------------------------------------------------
% 'M0601'
%----------------------------------------------------------------------------

%echo on;
%D = struct([]);
DF = 'M0601';
%--------------------------------------
% SPL = 75  75   Rho = 1
%dsIDp = '1-1-NTD-Q'; % no ITD-sensitivity
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '3-4-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '5-3-NTD'; % no ITD-selectivity
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '6-3-NTD'; % quick
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 200]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

dsIDp = '6-4-NTD'; % N = 5
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 200]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '6-6-NTD';
dsIDn = '6-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 280]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '10-10-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '11-3-NTD-Q'; % bandwidth 50 - 5000 Hz
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '11-4-NTD'; % bandwidth 50 - 8000 Hz
dsIDn = '11-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1
%dsIDp = '11-7-NTD'; % no response, interrupt
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '11-8-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

% SPL = 70  70   Rho = 1
dsIDp = '11-9-NTD'; % longer duration, 5/6 s
dsIDn = '11-10-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1 -1
dsIDp = '13-2-NTD';
dsIDn = '13-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 150]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '13-4-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y', 'YRange',[0 150]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1 -1
dsIDp = '14-2-NTD';
dsIDn = '14-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 100]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1
dsIDp = '14-14-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = -1
dsIDp = '14-15-NTD';
dsIDn = '14-16-NTD';
dsIDu = '14-17-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 0
%dsIDu = '15-4-NTD';
%ds1 = dataset(DF, dsIDu);
%T = EvalNITD(ds1, 'plot', 'y');
%T.tag = [0 1];
%D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
%dsIDp = '15-5-NTD'; % incomplete
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');
%T.tag = [0 1];
%D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '17-3-NTD'; %monaural right
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');

% SPL = 70  70   Rho = -1
%dsIDp = '17-4-NTD'; % monaural right
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');

% SPL = 30  30   Rho = -1
%dsIDp = '17-5-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '18-1-NTD-Q';
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '18-2-NTD'; % envelope cell
dsIDn = '18-3-NTD';
dsIDu = '18-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '21-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '23-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '23-5-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '23-6-NTD';
dsIDn = '23-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '23-13-NTD'; % poor response
dsIDn = '23-14-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = -1
dsIDp = '24-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '24-3-NTD';
dsIDn = '24-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 85  85   Rho = 1 -1 0
dsIDp = '24-6-NTD';
dsIDn = '24-7-NTD';
dsIDu = '24-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2, 'plot', 'y', 'YRange',[0 100]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '24-9-NTD'; % poor response
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 85  85   Rho = 1
dsIDp = '25-3-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 85  85   Rho = 1 -1
dsIDp = '25-4-NTD';
dsIDn = '25-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '25-7-NTD';
dsIDn = '25-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '26-2-NTD'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '28-1-NTD'; % very poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '29-3-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '30-2-NTD'; % weak response
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1
dsIDp = '30-3-NTD';
dsIDn = '30-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1
dsIDp = '30-5-NTD';
dsIDn = '30-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 0
%dsIDp = '30-7-NTD'; % for revcor
%ds1 = dataset(DF, dsIDp);

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '31-1-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '31-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '31-3-NTD'; % cell irritated
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1 -1
dsIDp = '32-3-NTD';
dsIDn = '32-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = -1
dsIDp = '33-2-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = -1
dsIDp = '33-3-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = -1
dsIDp = '33-4-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1
dsIDp = '33-5-NTD'; % cell habituates
dsIDn = '33-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1
%dsIDp = '33-10-NTD'; % interrupt (wrong range)
%ds1 = dataset(DF, dsIDp);

% SPL = 80  80   Rho = 1
dsIDp = '33-11-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1
dsIDp = '33-17-NTD';
dsIDn = '33-18-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = 1
dsIDp = '34-2-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1
%dsIDp = '34-3-NTD'; % unfinished - 2 cells
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

% SPL = 80  80   Rho = 1
%dsIDp = '34-4-NTD';
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

%--------------------------------------
% SPL = 80  80   Rho = 1
dsIDp = '35-3-NTD'; % quick run
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1
dsIDp = '35-4-NTD';
dsIDn = '35-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '35-14-NTD';
dsIDn = '35-15-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '35-20-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 


% SPL = 90  90   Rho = 1 -1
dsIDp = '35-21-NTD';
dsIDn = '35-22-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1 -1
dsIDp = '35-24-NTD';
dsIDn = '35-23-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '38-2-NTD-Q'; % quick
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 200]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '38-3-NTD';
dsIDn = '38-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '38-5-NTD'; % different ITD range than 38-3/4
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '38-6-NTD';
dsIDn = '38-7-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1 -1
dsIDp = '38-14-NTD';
dsIDn = '38-15-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '38-20-NTD'; % poor response
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '38-21-NTD'; % loosing cell
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '39-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);

% SPL = 70  70   Rho = 1
%dsIDp = '39-3-NTD'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

% SPL = 70  70   Rho = 1
dsIDp = '39-8-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1 0
dsIDp = '39-9-NTD';
dsIDn = '39-10-NTD';
dsIDu = '39-11-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 0
%dsIDp = '40-5-NTD-Q';
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '45-3-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'calcrange',[-3000 3000], 'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '46-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1 -1
dsIDp = '46-3-NTD';
dsIDn = '46-5-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 85  85   Rho = 1 -1
dsIDp = '46-7-NTD';
dsIDn = '46-6-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '46-9-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1 -1
dsIDp = '48-1-NTD-Q';
dsIDn = '48-2-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1
dsIDp = '48-8-NTD'; % 50 - 2000 Hz
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1 -1
dsIDp = '48-9-NTD'; % 50 - 2000 Hz
dsIDn = '48-10-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 75  75   Rho = 1 -1
dsIDp = '48-16-NTD'; % 50 - 2000 Hz, 5000 ms
dsIDn = '48-17-NTD'; % 50 - 2000 Hz, 5000 ms
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 60  60   Rho = 1 -1
dsIDp = '49-20-NTD';
dsIDn = '49-21-NTD-Q';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% long series with different bandwidths, only begin has been edited
if 0
% SPL = 60  60   Rho = 1 -1
dsIDp = '49-25-NTD-NB'; % 750-850 Hz
dsIDn = '49-26-NTD-NB';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y', 'YRange',[0 100]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1
dsIDp = '49-27-NTD-NB2'; % 700-900 Hz
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1
dsIDp = '49-28-NTD-NB4'; % 600-1000 Hz
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 60  60   Rho = 1 -1
dsIDp = '49-29-NTD-NB4'; % 600-1000 Hz
dsIDn = '49-30-NTD-NB4';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1 -1
dsIDp = '49-33-NTD';
dsIDn = '49-32-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y', 'YRange',[0 100]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-34-NTD-LP'; % 100-1000 Hz
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1 -1
dsIDp = '49-35-NTD-LP'; % 100-1000 Hz
dsIDn = '49-36-NTD-LP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1 -1
dsIDp = '49-38-NTD-HP'; % 1000-8000 Hz
dsIDn = '49-37-NTD-HP'; 
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-39-NTD-HP'; % wider ITD range
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,ds2,'plot', 'y', 'YRange',[0 150]);
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-40-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-41-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-42-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-43-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-44-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-45-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-46-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-47-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-48-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-49-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-50-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-51-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-52-NTD-BPS';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-53-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = -1
dsIDp = '49-54-NTD-BP-';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = -1
dsIDp = '49-55-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-56-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = -1
dsIDp = '49-57-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = -1
dsIDp = '49-62-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-63-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-70-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
ds3 = dataset(DF, dsIDu);
T = EvalNITD(ds1,ds2,ds3, 'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

% SPL = 55  55   Rho = 1
dsIDp = '49-71-NTD-BP'; % 1600-2000 Hz
dsIDn = '49-72-NTD-BP';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 
end
%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '50-1-NTD'; % quick
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 50  50   Rho = 1 -1
dsIDp = '50-2-NTD'; % weak response
dsIDn = '50-3-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 50  50   Rho = -1
%dsIDp = '51-1-NTD'; % no ITD-sensitivity
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 200]);

% SPL = 90  90   Rho = 1
%dsIDp = '51-2-NTD'; % no ITD-sensitivity
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 200]);

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '52-23-NTD'; % quick
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 200]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% (uncorrelated = 53-26-NTD)
% SPL = 70  70   Rho = 1 -1
dsIDp = '52-24-NTD'; % trougher
dsIDn = '52-25-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%----------------------------------------------------------------------------
% 'M0601B'
%----------------------------------------------------------------------------
DF = 'M0601B';


%--------------------------------------
% cell 53 = cell 52
% SPL = 70  70   Rho = 0
dsIDp = '53-26-NTD'; % 
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 3];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '55-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '57-5-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 200]);

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '58-1-NTD-Q'; % flat, no response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '60-2-NTD-Q';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 100]);
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '60-3-NTD';
dsIDn = '60-4-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y', 'YRange',[0 100]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

% SPL = 85  85   Rho = 1
dsIDp = '60-7-NTD'; % flat
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y', 'YRange',[0 100]);
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
dsIDp = '61-2-NTD-Q'; % noisy - bursts
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 70  70   Rho = 1
dsIDp = '61-3-NTD'; % noisy - bursts
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '62-3-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1, 'plot', 'y');

%--------------------------------------
% SPL = 90  90   Rho = 1
dsIDp = '68-4-NTD'; % quick
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 90  90   Rho = 1
dsIDp = '68-5-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 100 100   Rho = 1
dsIDp = '68-6-NTD';
ds1 = dataset(DF, dsIDp);
T = EvalNITD(ds1,'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% SPL = 80  80   Rho = 1 -1
dsIDp = '68-7-NTD'; % shorter duration
dsIDn = '68-8-NTD';
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalNITD(ds1,ds2,'plot', 'y');
T.tag = [0 1];
D = [D;T]; pause; close; %Z 

%--------------------------------------
% SPL = 80  80   Rho = -1
%dsIDp = '69-1-NTD-Q'; % poor response
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

%--------------------------------------
% SPL = 80  80   Rho = -1
%dsIDp = '70-2-NTD-Q'; % noisy
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

%--------------------------------------
% SPL = 70  70   Rho = 1
%dsIDp = '71-2-NTD-Q'; % flat
%ds1 = dataset(DF, dsIDp);
%T = EvalNITD(ds1,'plot', 'y');

save(mfilename, 'D');

if 0
%------------------------------------------------------------------------------------------------------------------
DNTD = D; clear D;
save psNDmonk.mat DNTD;
%------------------------------------------------------------------------------------------------------------------
end

echo off;


