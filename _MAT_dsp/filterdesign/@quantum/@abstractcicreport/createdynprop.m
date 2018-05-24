function createdynprop(this, datatype, intlog, comblog)
%CREATEDYNPROP   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

isdoublelog = false;
if strcmpi(datatype,'double'),
    isdoublelog = true;
end

nsec = this.nsections;
for i=1:nsec,
    if isdoublelog,
        p = schema.prop(this,['IntSect',num2str(i)],'quantum.abstractlog');
        this.(['IntSect',num2str(i)]) = quantum.doublelog(intlog{i});
        set(p, 'AccessFlags.Init', 'off', 'AccessFlags.PublicSet', 'off'); 
        
        p = schema.prop(this,['CombSect',num2str(i)],'quantum.abstractlog');
        this.(['CombSect',num2str(i)]) = quantum.doublelog(comblog{i});
        set(p, 'AccessFlags.Init', 'off', 'AccessFlags.PublicSet', 'off'); 
    else
        p = schema.prop(this,['IntSect',num2str(i)],'quantum.abstractlog');
        this.(['IntSect',num2str(i)]) = quantum.fixedlog(intlog{i});
        set(p, 'AccessFlags.Init', 'off', 'AccessFlags.PublicSet', 'off'); 
        
        p = schema.prop(this,['CombSect',num2str(i)],'quantum.abstractlog');
        this.(['CombSect',num2str(i)]) = quantum.fixedlog(comblog{i});
        set(p, 'AccessFlags.Init', 'off', 'AccessFlags.PublicSet', 'off'); 
    end
end


% [EOF]
