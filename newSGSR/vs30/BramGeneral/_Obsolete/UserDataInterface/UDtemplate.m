%-----------------------------------------------------------------
%                         Template
%-----------------------------------------------------------------
%The template must contain all the fields that can be given in this
%experiment script. If a fieldname isn't defined in this template, 
%then this is regarded as being a typing error. It also supplies 
%their default values.
%General information related to experiment ...
Experiment.Name = '';                 %Experiment name, should correspond
                                      %to the name of this m-file
Experiment.Aim = '';                  %The aim of the experiment
Experiment.Species = '';              %Name of species to which the animal
                                      %used in the experiment belongs. 
                                      %Restricted input: J(ava), R(hesus),
                                      %C(at), P (Guinea Pig), G(erbil)
Experiment.ExposedStr = '';           %Anatomical name of surgically exposed
                                      %structure. Restricted input: AN, CN, 
                                      %TB, SOC, IC, LL, DAS
Experiment.RecLoc = '';               %Histological structure from which was
                                      %recorded. Input not restricted. E.g. 
                                      %AVCN, PVCN, DCN, MSO, LSO, MNTB, ... 
Experiment.RecSide = '';              %Recording side                       
Experiment.StimChan = '';             %Active DA channels
Experiment.Eval = '';                 %General evaluation of experiment
 
%Information on individual cells ...
CellInfo.ExposedStr = 'from_experiment'; %Exposed structure can be overridden
                                         %for individual cells
CellInfo.RecLoc = 'from_experiment';     %Same for histological structure
CellInfo.RecSide = 'from_experiment';    %Recording side can also be overridden
CellInfo.iPen = NaN;                     %Penetration count
CellInfo.iPass = NaN;                    %Pass count within pen
CellInfo.HistDepth = NaN;                %Histological depth in micrometer
CellInfo.THRSeq = 'seq_th_last';         %Sequence number of good threshold curve
                                         %for that cell
CellInfo.Ignore = 0;                     %Ignore all the datasets recorded from
                                         %this cell. a possible reason can be 
                                         %given using the Eval-field
CellInfo.Eval = 'from_experiment';       %General evaluation of recordings from
                                         %this cell, additional information on 
                                         %physiological behaviour of this cell
                                         %(e.g. trougher)
%Information on datasets ...
DSInfo.Ignore = 'from_cellinfo';      %Ignore this dataset completely. Use Eval-
                                      %field to supply a possible reason
DSInfo.Eval = 'from_cellinfo';        %Evaluation of recording
DSInfo.BadSubSeq = [];                %List of subsequences with bad recordings
%-----------------------------------------------------------------
%                         Data
%-----------------------------------------------------------------
%Attention! Actual data related to experiment must be given in the template.
%Examples of possible syntax:
%
%Simple assignment of a field, in this particular case to field HistDepth is
%set to 200 for the cell with number one ...
%CellInfo_1.HistDepth = 200; 
%
%To reduce the amount of typing, the assignment of different values for a field
%to multiple cells can be done all on one line. This kind of assignment is 
%called 'vector' assignment, hence the token vec used in the syntax ... 
%The example assigns the value 340 to the field HistDepth for cell 2, the value
%400 to that same field for the cell 3, and so on ...
%CellInfo_2_vec.HistDepth = { 340, 400, 600, 700, 800 };
%
%Range assignment allows you to assign values to a field for a range of cells. 
%In the example, the field iPen is set to the value one for all cells from 1 to 12.
%CellInfo_1_12.iPen = 1;
%
%When using range assignment, the last cell number specifying the range can be set
%to Inf(inite), denoting the last cell from which was recorded during the experiment.
%Now the field iPen is set to two for all cells from 12 onwards ...
%CellInfo_12_Inf.iPen = 2;
%
%For datasets, the same syntax rules apply except that a dataset is specified by its
%cell number combined with its test number separated by an underscore ...
%DSInfo_1_1.Ignore = 1;                                   %Simple assignment ...
%DSInfo_1_2_vec.BadSubSeq = { 12:40, [40,41], 30:50 };    %Vector assignment ...
%DSInfo_1_2_2_3.Eval = '';                                %Range assignment ...
%DSInfo_1_2_Inf_Inf.Ignore = 1;