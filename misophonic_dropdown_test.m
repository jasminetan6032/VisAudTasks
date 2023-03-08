% misophonic_sound = [];
% 
% fig = uifigure;
% dd = uidropdown(fig,'Items',{'chewing','nail_clipping','joint_cracking','snoring'},...
%                      'Value','chewing',...
%                      'ValueChangedFcn',@(dd,event) selection(dd));
% 
% Create ValueChangedFcn callback:
% function misophonic_sound = selection(dd)
% misophonic_sound = dd.Value;
% end


% fig = uifigure; 
% fig.Position(3:4) = [440 320];
% 
% ax = uiaxes('Parent',fig,...
%     'Position',[10 10 300 300]);
% 
% 
% x = linspace(-2*pi,2*pi);
% y = sin(x);
% p = plot(ax,x,y);
% p.Color = 'Blue';
% 
% dd = uidropdown(fig,...
%     'Position',[320 160 100 22],...
%     'Items',{'Red','Yellow','Blue','Green'},...
%     'Value','Blue',...
%     'ValueChangedFcn',@(dd,event) selection(dd));
% 
% % Create ValueChangedFcn callback:
% function selection(dd)
% print str(dd.Value);
% end

list = {'chewing','nail_clipping','joint_cracking','snoring'};
[indx,tf] = listdlg('ListString',list);
misophonic_sound = list{indx};