%                  EDFDATASET SUBSCRIPTED REFERENCE
%
%    Below is a list of allowed fields, their contents, 
%    and a sample value if relevant. DS is a dataset object.
%    DS.name/name2 means: DS.name1 or, equivalently, DS.name2.
%    The fields are case insensitive.
%    
%    Syntax                Meaning                  Sample value
%    -----------------------------------------------------------
%    DS.help            Shows this help text
%    -----------------------------------------------------------
%    DS.id              Struct containing ID info
%    DS.filename        Raw data filename           R97047
%    DS.fullfile        Full filename of raw data   C:\USR\Bram\R97947.DAT
%    DS.fileformat      Raw data format             EDF
%    DS.seqid/condid    Unique identifier           <1-11-MOV1>
%    DS.iseq            Seq # in data file          14
%    DS.exptype         Experiment type             RA
%    DS.schname         Schema name                 SCH012
%    DS.icell           Cell number                 1
%    DS.time            Date/time vector            [1997 6 12 23 7 16.1]
%    DS.place           Lab and PC                  University of Wisconsin (Madison)
%    DS.title           Quick plot title            R97047  <1-11-MOV1>
%    DS.pres            Short info on presentation  10/10 x 2 x 2000 ms
%    -----------------------------------------------------------
%    DS.timernrs        Numbers of the event timers used
%    -----------------------------------------------------------
%    DS.dss             Struct containing information on the DSSs
%    DS.dssnr           Number of DSSs used
%    DS.mdssnr          Number of master DSS
%    DS.mdssmode        Mode of Master DSS
%    DS.sdssnr          Number of slave DSS
%    DS.sdssmode        Mode of slave DSS
%    -----------------------------------------------------------
%    DS.mgwfile         General Waveform filename for master DSS
%    DS.mgwid           Dataset ID for General WaveForm for master DSS
%    DS.sgwfile         General Waveform filename for slave DSS
%    DS.sgwid           Dataset ID for General WaveForm for slave DSS
%    -----------------------------------------------------------
%    DS.sizes           Struct containing Nsub, etc
%    DS.nsub/ncond      # conditions (=subsequences)
%    DS.nsubrecorded/nrec # recorded conditions   
%    DS.nrep/nrun       # repetitions (=runs)
%    DS.ntimers         # event timers
%    -----------------------------------------------------------
%    DS.data            Struct containing all raw data
%    DS.spiketimes/spt  Spike times in Nsub x Nrep cell array
%    DS.spiketimes0/spt0 ... DS.spiketimes15/spt15
%                       Spiketimes collected with specified event timer
%                       in Nsub x Nrep cell array
%    DS.spiketimes3d/spt3d
%                       Spike times in NvarX x NvarY x Nrep cell array
%    DS.otherdata       Exceptional raw data (e.g. TH or CALB curve)
%    -----------------------------------------------------------
%    DS.stimulus/stim   Struct containing stimulus info
%
%    Virtual fields for retrieving information on independent variables
%    are still in development ...
%
%    DS.special         Special stim params in Struct
%    DS.repdur          Duration of repetition in ms
%    DS.burstdur        Duration of burst in ms
%    DS.carfreq/fcar    Carrier freq (in Hz) if applicable
%    DS.modfreq/fmod    Modulation freq (in Hz) if applicable
%    DS.beatfreq/fbeat  Beat freq (in Hz) if applicable
%    DS.beatmodfreq/fbeatmod ...
%                       Modulation Beat freq (in Hz) if applicable
%    DS.dachan/chan/activechan ...
%                       Active DA channel (0,1,2 = Both,Left,Right)
%    DS.stimparam/param/spar ...
%                       Detailed stimulus parameters
%    -----------------------------------------------------------
%    ds.schdata         Original schema for this dataset
%    -----------------------------------------------------------
%    ds.dataset         Parent dataset object fields
%    -----------------------------------------------------------
%    DS.XXX, where XXX is an existing field of DS.spar accesses that
%    field directly