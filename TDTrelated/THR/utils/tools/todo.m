% todo - what to do
%    - purge seqplay circuit
%    - datagrabbers should have more info on what they grab. In particular
%      info on the hardware, how to get current hardware settings, etc.
%    experiment GUI: 2nd AD should have MIC-1, etc
%    experiment GUI: probe #2 spec required even if not used
%    include across-stim interval?
%    hidden axis of dot raster is not cleared by clf
%    GUImessage: focus switch
%    Nan-Nan-FS -> think of something better
%    Crt-Q on cyclehisto yields dotraster??
%    dataviewer: what is status of its data after completed recording?
%    D naming of AD channels Analog1, analog2 does not relate to experiment
%                AD channels
%    D dataviewer crashes when no spikes are recorded
%    ++++++++++++++++++++++++++++++++++++++++
%    D STOP fails again ......
%    D D/A hickup: controlled sys3write (circuit running? transfer speed?)
%    D AD offset problems. Hardware reset from Matlab?? Memory problem? yes
%    - simple background process checking connection w RX6??
%    D cleanup hoards when not saving
%    - reset/hardware reset, memorytest & all that
%    - GUIs: allow "hidden" queries that are read & saved, but whose
%      setting and displaying is delegated to a descendant GUI launched when
%      clicking a button. Needs adapatation of GUIval, GUIgrab, GUIfil ...
%    - create parent class of paramQuery, etc (e.g. below method).
%    - clean up eventdata constructor and its analogs
%    - finish dataviewparam stuff; add stimorder method to stimpresent class.
%    D clean up dataviewparam shit!!
%    - make sure that if a timer fails, the others are handle as well as
%      possible.
%    D incorporate params in dotraster
%    ~ improve strictness of sys3write security (also consider upload
%      time?) [added pre-writing random values to prevent unjust approvals]
%      Needed in any event: in case of retries, test all written values.
%    - concatenate bin files for ADC data?
%    - slow dataviewer interferes with stopper. Automatically adapt timer speed?
%    - optimize dataset/spiketimes using monotonicity of arrival times
%
%    D 'Cannot stop a actabit object whose status is 'prepared'
%    D include experiment btn in dashboard
%    ~ clean up stimGUImode, stimGUIaction
%    - clean up the way current exp is used in stimcontext
%    D keep dataset index in experiment -> use Exp method
%    D stringExtent.ncache ??
%    - introduce dataset postprocessing, reducing analog data (snippets, etc)
%    - make seqplay stuff device specific
%
%    - klone experiment: 2nd arg to exp/edit
%
%    - fix artigerbil
%    - incorporate acoust calibration delays in event timing
%    - sorting order dotraster -> generalize condition sorting
%    D cleanup event grabbing implementation
%    D implement stimpresent
%    ~ switch to real pointers, get rid of upload/download
%    D use HOARDS
%    - improve HOARDS by making them children of the GUI
%    D simple figure-position saver, also for GUIs
%    - centralize Hardwareinfo like triggers for calib, buffer resets, etc
%    - make timing calibration dependent on circuit loading
%
%    - repetitive play -> playsound/oneshot
%    - "push" fcn mimicking GUI callbacks
%    - local settings GUI
%    - generic zero playbuffer like in SGSR
%    D analog recordings (ZWOAE)
%    ~ dynamic online data analysis
%    - (R'dam) test spike time accuracy (LP filter)
%
help todo






