
%------------------------------------------------------------------------------------------------------------------
%                                 psNDmonkPM SCRIPT for population analysis of NITD-data
%------------------------------------------------------------------------------------------------------------------
% created by PXJ 14-04-2006 based on popscripts created by Myles
%
% tag 1: identifies "primary" dataset of NTD responses for a given cell
% tag 2: identifies "secondary" sets of NTD responses for a given cell, i.e. sets that are not the "best"
% tag 3: identifies datasets that are NOT fit for best delay analysis (stereausis paper)
% if multiple NTD datasets (at different SPLs): sorted in ascending SPL ']
%
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
% 26/09 enkel IID effecten in M0545D laten staan. Plot specifiek IID effecten op ITD curves, gebaseerd op 3 neuronen in M0545. 
% Plots worden op vaste MBLs gemaakt. 
% PM


D = struct([]);

%=============================================
% test M0545D
%=============================================

DF = 'M0545D'

%------------------------------------------------------------------
% neuron 98 : MBL 70
%------------------------------------------------------------------

% neuron 98
% SPL = 60  80   Rho = 1
dsIDp = '98-31-NTD'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; %Z 

% neuron 98
% SPL = 80  60   Rho = 1
dsIDp = '98-32-NTD'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% IID effects on neuron 98
% SPL 60|80 vs SPL 80|60 
dsIDp = '98-31-NTD'; % with ILD 60-80!
dsIDn = '98-32-NTD'; % with ILD 80-60!
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalND(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%------------------------------------------------------------------
% neuron 110 : MBL 70
%------------------------------------------------------------------

%neuron 110
% SPL = 60  80   Rho = 1
% onvoldoende gegevens voor correcte plot? "no plot to be generated" MSG.
% dsIDp = '110-8-NTD-6080'; % with ILD!
% ds1 = dataset(DF, dsIDp);
% T = EvalND(ds1, 'plot', 'y');
% T.tag = [0 2];
% D = [D;T]; pause; close; %Z 

% neuron 110
% SPL = 60  80   Rho = 1
dsIDp = '110-11-NTD-6080'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% neuron 110
% SPL = 80  60   Rho = 1
dsIDp = '110-12-NTD-8060'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% IID effects on neuron 110
% SPL 60|80 vs SPL 80|60 
dsIDp = '110-11-NTD-6080'; % with ILD 60-80!
dsIDn = '110-12-NTD-8060'; % with ILD 80-60!
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalND(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% neuron 110
% SPL = 50|90   Rho = 1
dsIDp = '110-13-NTD-5090'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% IID effects on neuron 110
% SPL 60|80 vs SPL 50|90 
dsIDp = '110-11-NTD-6080'; % with ILD 60-80!
dsIDn = '110-13-NTD-5090'; % with ILD 50-90!
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalND(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 


% neuron 110
% SPL = 90|50   Rho = 1
dsIDp = '110-14-NTD-9050'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% IID effects on neuron 110
% SPL 60|80 vs SPL 90|50 
dsIDp = '110-11-NTD-6080'; % with ILD 60-80!
dsIDn = '110-14-NTD-9050'; % with ILD 90-50!
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalND(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% IID effects on neuron 110
% SPL 50|90 vs SPL 90|50 
dsIDp = '110-13-NTD-5090'; % with ILD 50-90!
dsIDn = '110-14-NTD-9050'; % with ILD 90-50!
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalND(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% opgelet: verandering in MBL !

%------------------------------------------------------------------
% neuron 110 : MBL 65
%------------------------------------------------------------------

% neuron 110
% SPL = 60  70   Rho = 1
dsIDp = '110-15-NTD-6070'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% neuron 110
% SPL = 70  60   Rho = 1
dsIDp = '110-17-NTD-7060'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% IID effects on neuron 110
% SPL 60|70 vs SPL 70|60 
dsIDp = '110-15-NTD-6070'; % with ILD 60-70!
dsIDn = '110-17-NTD-7060'; % with ILD 70-60!
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalND(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%------------------------------------------------------------------
% neuron 110 : MBL 75
%------------------------------------------------------------------

% neuron 110
% SPL = 80  70   Rho = 1
dsIDp = '110-16-NTD-8070'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 


% neuron 110
% SPL = 70  80   Rho = 1
dsIDp = '110-18-NTD-7080'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% IID effects on neuron 110
% SPL 60|70 vs SPL 70|60 
dsIDp = '110-16-NTD-8070'; % with ILD 80-70!
dsIDn = '110-18-NTD-7080'; % with ILD 70-80!
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalND(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

%------------------------------------------------------------------
% neuron 112 : MBL 70
%------------------------------------------------------------------

% neuron 112
% SPL = 60  80   Rho = 1
dsIDp = '112-6-NTD-6080'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% neuron 112
% SPL = 80  60   Rho = 1
dsIDp = '112-7-NTD-8060'; % with ILD!
ds1 = dataset(DF, dsIDp);
T = EvalND(ds1, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

% IID effects on neuron 112
% SPL 60|80 vs SPL 80|60 
dsIDp = '112-6-NTD-6080'; % with ILD 60-80!
dsIDn = '112-7-NTD-8060'; % with ILD 80-60!
ds1 = dataset(DF, dsIDp);
ds2 = dataset(DF, dsIDn);
T = EvalND(ds1,ds2, 'plot', 'y');
T.tag = [0 2];
D = [D;T]; pause; close; %Z 

end 
