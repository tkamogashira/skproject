dbox = java.awt.Frame;
dbox.setLayout(java.awt.GridLayout(2,1));
dbox.setLocation(50,150);
dbox.resize(200,100)

set(dbox,'background',[0.3 0.4 0.5])
txt = java.awt.Label('HELP',1)
but = java.awt.Button('LS')
set(but,'background',[0.7 0.7 0.5])
set(but,'mouseclickedcallback', 'who')
dbox.add(txt);
dbox.add(but);
dbox.show







