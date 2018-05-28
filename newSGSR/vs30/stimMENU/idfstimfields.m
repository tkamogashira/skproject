function [chan, sctrl, s1, s2, scm, chanNum, order] = idfstimfields(idfSeq)
% temporary function that intercepts 'R' DA mode for IDF sequences XXX
% should be updated after installing a second SS1
    
    % default order, is difefrent for different stimmenus
    if isfield(idfSeq, 'order')
        order = idfSeq.order;
    elseif ismember(idfSeq.stimcntrl.stimtype,[5 21 23])
        order = 1; % ITD/CTD/NTD
    else
        order = 0;
    end
    
    chanNum = idfSeq.stimcntrl.activechan;
    chans = 'BLR';
    chan = chans(chanNum+1);
    sctrl = idfSeq.stimcntrl;
    if isfield(idfSeq.indiv,'stimcmn')
        scm = idfSeq.indiv.stimcmn;
    else
        scm = [];
    end
    if (chan=='R') && ~TwoSS1s
        % warning('''R'' DA mode not yet implemented - will swap L&R channels');
        chan = 'L';
        chanNum = 1;
        s1 = idfSeq.indiv.stim{2};
        s2 = idfSeq.indiv.stim{1};
        % fucked-up NTD/NSPL menus: undo undesired swapping of tricked params
        if isequal('ntd', idfstimname(idfSeq.stimcntrl.stimtype)) || ...
                isequal('nspl',idfstimname(idfSeq.stimcntrl.stimtype))
            s1.noise_data_set = idfSeq.indiv.stim{1}.noise_data_set;
            s1.file_name = idfSeq.indiv.stim{1}.file_name;
            s1.sample_rate = idfSeq.indiv.stim{1}.sample_rate;
            s2.noise_data_set = idfSeq.indiv.stim{2}.noise_data_set;
            s2.file_name = idfSeq.indiv.stim{2}.file_name;
            s2.sample_rate = idfSeq.indiv.stim{2}.sample_rate;
        end
    else
        s1 = idfSeq.indiv.stim{1};
        s2 = idfSeq.indiv.stim{2};
    end
end
