function showtab(this, tab)
%SHOWTAB   Show the specified tab.

%   Copyright 1999-2011 The MathWorks, Inc.

h   = get(this, 'Handles');
vis = get(this, 'Visible');

if isa(this.Filter, 'mfilt.abstractcic')
    switch tab
        case 1
            % NO OP, should never happen
        case 2
            hi = getcomponent(this, 'tag', 'input');
            ho = getcomponent(this, 'tag', 'output');
            set([hi ho], 'Visible', vis);

            set(h.inputdivider, 'Visible', vis);
        case 3
            set([h.sectionwordlengths_lbl h.sectionwordlengths ...
                h.sectionfraclengths_lbl h.sectionfraclengths h.modedivider ...
                h.roundmode h.roundmode_lbl h.overflowmode ...
                h.overflowmode_lbl h.sectionfraclengths], 'Visible', vis);
            
            hp = getcomponent(this, 'tag', 'product');
            ha = getcomponent(this, 'tag', 'accum');
            hts = getcomponent(this, 'tag', 'tapsum');
            hs = getcomponent(this, 'tag', 'state');
            hm = getcomponent(this, 'tag', 'multiplicand');
            set([hs hp ha hts hm], 'Visible', 'off');
            set([h.proddivider h.accumdivider h.statedivider ...
                h.castbeforesum], 'Visible', 'off');
    end
else
    if issupported(this),
        info = qtoolinfo(this.Filter);
    else
        info = [];
    end

    switch tab
        case 1
            set([h.unsigned h.coeffdivider], 'Visible', vis);
            hc = getcomponent(this, 'tag', 'coeff');
            set(hc, 'Visible', vis);
            if issupported(this)
                info = qtoolinfo(this.Filter);
                if isfield(info, 'normalize')
                    set(h.normalize, ...
                        'String', getString(message('dsp:fdtbxgui:fdtbxgui:ScaleCoefficientsFully', info.normalize)));
                    set(h.normalize_extra, 'String', getString(message('dsp:fdtbxgui:fdtbxgui:UtilizeDynamicRange')));
                    vis  = this.Visible;
                else
                    vis  = 'Off';
                end

                set([h.normalize h.normalize_extra], 'Visible', vis);
                cshelpcontextmenu(h.normalize, 'fdatool_qtool_entiredynamicrange\dsp','fdatool');
                cshelpcontextmenu(h.normalize_extra, 'fdatool_qtool_entiredynamicrange\dsp','fdatool');
            end

        case 2
            hi = getcomponent(this, 'tag', 'input');
            ho = getcomponent(this, 'tag', 'output');
            set([hi ho], 'Visible', vis);

            set(h.inputdivider, 'Visible', vis);

            if isfield(info, 'sectionoutput'), visState = vis;
            else                             visState = 'Off'; end

            hsi = getcomponent(this, 'tag', 'sectioninput');
            hso = getcomponent(this, 'tag', 'sectionoutput');
            set([hsi hso], 'Visible', visState);
            set(h.sectiondivider, 'Visible', visState);

            if isfield(info, 'sectionoutput'), visState = vis;
            else                             visState = 'Off'; end
            set(h.outputdivider, 'Visible', visState);

        case 3
            set([h.sectionwordlengths_lbl h.sectionwordlengths ...
                h.sectionfraclengths_lbl h.sectionfraclengths], 'Visible', 'off');

            set([h.roundmode h.roundmode_lbl h.overflowmode h.overflowmode_lbl ...
                h.castbeforesum], 'Visible', vis);
            ha = getcomponent(this, 'tag', 'accum');
            accumvis = vis;
            if isfield(info, 'accum')
                if isempty(info.accum)
                    accumvis = 'off';
                end
            end
            set(h.modedivider, 'Visible', accumvis);
            set(ha, 'Visible', accumvis);
            hp = getcomponent(this, 'tag', 'product');
            prodvis = vis;
            if isfield(info, 'product')
                if isempty(info.product)
                    prodvis = 'off';
                end
            end
            set(hp, 'Visible', prodvis);
            set(h.proddivider, 'Visible', prodvis);

            if isfield(info, 'tapsum'), visState = vis;
            else                        visState = 'Off'; end
            hts = getcomponent(this, 'tag', 'tapsum');
            set(hts, 'Visible', visState);

            if isfield(info, 'state'), visState = vis;
            else                       visState = 'Off'; end
            hs = getcomponent(this, 'tag', 'state');
            set(hs, 'Visible', visState);

            if isfield(info, 'state') || isfield(info, 'tapsum')
                visState = vis;
            else
                visState = 'Off';
            end
            set(h.accumdivider, 'Visible', visState);

            if isfield(info, 'multiplicand'), visState = vis;
            else                              visState = 'Off'; end
            hm = getcomponent(this, 'tag', 'multiplicand');
            set(hm, 'Visible', visState);
            set(h.statedivider, 'Visible', visState);
        otherwise
            error(message('dsp:fdtbxgui:qtool:showtab:InternalError'));
    end
end

% [EOF]
