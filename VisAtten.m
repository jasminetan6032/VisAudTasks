function [p_events, reactionTime, events, correctTrials]= VisAtten(ntrials,use_trigs)

cd /homes/7/jwt30/Documents/MATLAB


% added 5 and 6 condition
uiwait(helpdlg('Lights at 50? A/Cs OFF??', 'TIRGGERS BOX ON USB?????'));
% clear the workspace
if nargin<2
    % Use triggers or not
    use_trigs=0;
end

if nargin<1
    % ntrials is ****HALF**** the number of trials per condition!!!
    % So if we want 4 trials per condition, must enter 8 here!!!!
    ntrials=66;
end

subjectID = input('Enter the subject name:','s');
KbName('UnifyKeyNames');


if use_trigs
    % initiate trigger:
    di = DaqDeviceIndex;
    DaqDConfigPort(di,0,0);
    DaqDOut(di,0,0);
end

nevents = 4; %% THIS SHOULD REALLY BE CALLED THE NUMBER OF CONDITIONS per "type", search or popoout!!!! 8 CONDITIONS.
% here we set the size of the arms of our fixation cross
fixcrossdimpix = 10;

% now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xcoords = [-fixcrossdimpix fixcrossdimpix 0 0];
ycoords = [0 0 -fixcrossdimpix fixcrossdimpix];
allcoords = [xcoords; ycoords];

% set the line width for our fixation cross
linewidthpix = 2;

% assertopengl;
% Screen('preference','verbosity',0);
% Screen('preference','visualdebuglevel',0);

% get the list of screens and choose the one with the highest screen number.
screennumber=max(Screen('screens'));

% find the color values which correspond to white and black.
white=WhiteIndex(screennumber);
black=BlackIndex(screennumber);

% round gray to integral number, to avoid roundoff artifacts with some
% graphics cards:
gray=round((white+black)/2);

% this makes sure that on floating point framebuffers we still get a
% well defined gray. it isn't strictly neccessary in this demo:
if gray == white
    gray=white / 2;
end


% open a double buffered fullscreen window with a gray background:
AssertOpenGL;
Screen('Preference','Verbosity',0);
Screen('Preference','VisualDebuglevel',0);
screenNumber=max(Screen('Screens'));
Screen('Preference', 'SkipSyncTests', 1);
[w screenrect]=Screen('openwindow',screennumber, gray);
[xcenter, ycenter] = RectCenter(screenrect);
Screen('blendfunction', w, 'gl_src_alpha', 'gl_one_minus_src_alpha');



texsize=25; % half-size of the grating image.
radius = 120;
visiblesize=2*texsize+1;
visible2size=visiblesize/2;

offsets = cell(1);

events = repmat(1:nevents, 1,ntrials);
events = events(randperm(length(events)));
shape_events = events(randperm(length(events)));
color_events = events(randperm(length(events)));


% Determines if search or popout. Make half of each (1 or 0), then shuffle.
% That's the order it'll be...

p_events = zeros(1,length(events));
p_events(1:round(length(events)/2)) = 1;
p_events = p_events(randperm(length(p_events)));
p_events = p_events(randperm(length(p_events)));


for index =1:nevents
    if index==1
        
        offsets{index} = [(cos(45 *(pi / 180)) .* radius) (sin(45 *(pi / 180)) .* radius);
            (cos(135 *(pi / 180)) .* radius) (sin(135 *(pi / 180)) .* radius);
            (cos(225 *(pi / 180)) .* radius) (sin(225 *(pi / 180)) .* radius);
            (cos(315 *(pi / 180)) .* radius) (sin(315 *(pi / 180)) .* radius)];
    elseif index==2
        offsets{index} = [(cos(0 *(pi / 180)) .* radius) (sin(0 *(pi / 180)) .* radius);
            (cos(45 *(pi / 180)) .* radius) (sin(45 *(pi / 180)) .* radius);
            (cos(135 *(pi / 180)) .* radius) (sin(135 *(pi / 180)) .* radius);
            (cos(180 *(pi / 180)) .* radius) (sin(180 *(pi / 180)) .* radius);
            (cos(225 *(pi / 180)) .* radius) (sin(225 *(pi / 180)) .* radius);
            (cos(315 *(pi / 180)) .* radius) (sin(315 *(pi / 180)) .* radius)];
        
    elseif index==3
        offsets{index} = [(cos(20 *(pi / 180)) .* radius) (sin(20 *(pi / 180)) .* radius);
            (cos(60 *(pi / 180)) .* radius) (sin(60 *(pi / 180)) .* radius);
            (cos(120 *(pi / 180)) .* radius) (sin(120 *(pi / 180)) .* radius);
            (cos(160 *(pi / 180)) .* radius) (sin(160 *(pi / 180)) .* radius);
            (cos(200 *(pi / 180)) .* radius) (sin(200 *(pi / 180)) .* radius);
            (cos(240 *(pi / 180)) .* radius) (sin(240 *(pi / 180)) .* radius);
            (cos(300 *(pi / 180)) .* radius) (sin(300 *(pi / 180)) .* radius);
            (cos(340 *(pi / 180)) .* radius) (sin(340 *(pi / 180)) .* radius)];
    elseif index==4
        offsets{index} = [(cos(0 *(pi / 180)) .* radius) (sin(0 *(pi / 180)) .* radius);
            (cos(30 *(pi / 180)) .* radius) (sin(30 *(pi / 180)) .* radius);
            (cos(60 *(pi / 180)) .* radius) (sin(60 *(pi / 180)) .* radius);
            (cos(120 *(pi / 180)) .* radius) (sin(120 *(pi / 180)) .* radius);
            (cos(150 *(pi / 180)) .* radius) (sin(150 *(pi / 180)) .* radius);
            (cos(180 *(pi / 180)) .* radius) (sin(180 *(pi / 180)) .* radius);
            (cos(210 *(pi / 180)) .* radius) (sin(210 *(pi / 180)) .* radius);
            (cos(240 *(pi / 180)) .* radius) (sin(240 *(pi / 180)) .* radius)
            (cos(300 *(pi / 180)) .* radius) (sin(300 *(pi / 180)) .* radius);
            (cos(330 *(pi / 180)) .* radius) (sin(330 *(pi / 180)) .* radius)];
    
    end
end




% definition of the drawn rectangle on the screen:
dst2rect=[0 0 visible2size visible2size];
dst2rect=CenterRect(dst2rect, screenrect);

colorcodes = {[255 0 0]; [0 255 0]; [0 0 255]; [255 255 0]};



Screen('fillrect', w,gray);
Screen('textsize', w, 40);
% Trying to figure out how to make this screen show up on the right
% screen...
%%%w = Screen('OpenWindow',screenNumber, gray);
%DrawFormattedText(w, 'Please keep your eyes on the cross', 'center',...
%  ycenter-100, white);
%%WaitSecs(2);KbWait

Screen('TextSize', w, 60);
DrawFormattedText(w, 'We are about to begin... ', 'center','center', white);
Screen('Flip', w);
%% WaitSecs(2);KbWait
uiwait(helpdlg('CLICK WHEN READY TO START!!!'));


ListenChar(2); % suppresseskeypresses to the matlab window


Screen('drawlines', w, allcoords,linewidthpix, [0 0 0], [xcenter ycenter],1);
Screen('flip', w);
Screen('fillrect', w,gray);
Screen('drawlines', w, allcoords,linewidthpix, [0 0 0], [xcenter ycenter],1);
Screen('flip', w);
WaitSecs(1+rand(1)*.2);
% animationloop:
reactionTime  = zeros(1,ntrials * nevents).*NaN;
correctTrials  = zeros(1,ntrials * nevents).*NaN;

for i=1:ntrials * nevents
    disp(['trial number is: ' num2str(i) '--Out Of--autofs/space/transcend/MEG/Stimuli_MATLAB_scripts_Nov04_2021:' num2str(ntrials * nevents)])
    selected_event = offsets{events(i)};
    Screen('fillrect', w,gray);
    % cue
    
    plotshapes(w,dst2rect,shape_events(i),colorcodes{color_events(i)},texsize,0, 0,xcenter, ycenter)
    for ii=1:size(selected_event,1)
        plotshapes(w,dst2rect,5,[255 255 255],texsize,selected_event(ii,1), selected_event(ii,2),xcenter, ycenter)
    end
    Screen('flip', w);
    if use_trigs
        DaqDOut(di,0,32);  %send trigger
        DaqDOut(di,0,0);  %clear trig
    end
    WaitSecs(.8);
    Screen('fillrect', w,gray);
    Screen('drawlines', w, allcoords,linewidthpix, [0 0 0], [xcenter ycenter],1);
    
    
    distracter_shape = 1:4;
    
    
    distracter_color = 1:4;
    
    
    traget_location = randperm(size(selected_event,1));
    traget_location = traget_location(1);
    if p_events(i) == 1
        distracter_color(color_events(i)) = [];
        distracter_shape(shape_events(i)) = [];
    end
    
    for ii=1:size(selected_event,1)
        
        if ii == traget_location
            
            
            plotshapes(w,dst2rect,shape_events(i),colorcodes{color_events(i)},texsize,selected_event(ii,1), selected_event(ii,2),xcenter, ycenter)
        else
            
            while 1
                
                t1 = randi(length(distracter_color),1);
                t2 = randi(length(distracter_shape),1);
                if distracter_color(t1)==color_events(i) && distracter_shape(t2)==shape_events(i)
                    continue;
                elseif distracter_color(t1)~=color_events(i) && distracter_shape(t2)==shape_events(i)
                    break;
                elseif distracter_color(t1)==color_events(i) && distracter_shape(t2)~=shape_events(i)
                    break;
                elseif distracter_color(t1)~=color_events(i) && distracter_shape(t2)~=shape_events(i) && p_events(i)
                    break;
                end
           
            end
            plotshapes(w,dst2rect,distracter_shape(t2),colorcodes{distracter_color(t1)},...
                texsize,selected_event(ii,1), selected_event(ii,2),xcenter, ycenter)
            
        end
    end
    %KbQueueStart;
    Screen('flip', w);
    rt=tic;
    if use_trigs
        DaqDOut(di,0,((p_events(i)*4) + events(i)));  %send trigger
        DaqDOut(di,0,0);  %clear trig     
    end
    
    
    
    
    
 % read keyboard input here, using KbWAit - meaning it won't proceed until
 % a key is pressed.
 if 1
        [~, keyCode] = KbWait;
        reactionTime(i)=toc(rt);
        
        %% p = 34, right side, and q=25, left side - added options for keyboard inputs
        
        if find(keyCode==1)==11 || find(keyCode==1)==12 || find(keyCode==1)==13 || find(keyCode==1)==14 || find(keyCode==1)==34
            flag1 = 1;
            if sign(selected_event(traget_location,1))==flag1
                disp('     ******* Trial CORRECT')
            else
                disp('     >>>>>>> Trial NOT correct')
            end
        elseif find(keyCode==1)==16 || find(keyCode==1)==17 || find(keyCode==1)==18 || find(keyCode==1)==19 || find(keyCode==1)==25
            flag1= -1;
            if sign(selected_event(traget_location,1))==flag1
                disp('   ********** Trial CORRECT')
            else
                disp('       >>>>>>>  Trial NOT correct  <<<<<<<<<<<<')
            end

        else
            continue;
        end
        correctTrials(i) = sign(selected_event(traget_location,1))==flag1;
        disp(['trial type and Trigger Number is: ' num2str((p_events(i)*4) + events(i))])
        disp(['reaction time is: ' num2str(reactionTime(i)*1000)])
    end
     
    WaitSecs(.5+rand(1)*.2);
    

end

%%% Main function ended. Other functions:

    function plotshapes(w,dst2rect,type,color,texsize,xcenteroff, ycenteroff,xcenter, ycenter)
        dst2rect(1:2:end) = dst2rect(1:2:end) + xcenteroff;
        dst2rect(2:2:end) = dst2rect(2:2:end) + ycenteroff;
        
        if type ==1
            Screen('fillrect', w, color, dst2rect)
        elseif type ==2
            Screen('filloval', w, color, dst2rect)
        elseif type==3
            angles = linspace(90, 360+90, 5 + 1);
            angles = angles * (pi / 180);
            radius = (texsize+5) / 2;
            yposvector = sin(angles) .* radius + ycenter+ycenteroff;
            xposvector = cos(angles) .* radius + xcenter+ xcenteroff;
            Screen('fillpoly', w, color, [xposvector; yposvector]', 1);
        elseif type==5
            angles = linspace(90, 360+90, 8 + 1);
            angles = angles * (pi / 180);
            radius = (texsize+5) / 2;
            yposvector = sin(angles) .* radius + ycenter+ycenteroff;
            xposvector = cos(angles) .* radius + xcenter+ xcenteroff;
            Screen('fillpoly', w, color, [xposvector; yposvector]', 1);
        elseif type==4
            angles = linspace(90, 360+90, 3 + 1);
            angles = angles * (pi / 180);
            radius = (texsize+15) / 2;
            yposvector = sin(angles) .* radius + ycenter+ycenteroff;
            xposvector = cos(angles) .* radius + xcenter+ xcenteroff;
            Screen('fillpoly', w, color, [xposvector; yposvector]', 1);
            
            
            
        end
    end


disp(['mean Correct Trials are: ' num2str(mean(correctTrials)*100)])

dateString=datestr(now);
dateString(dateString==' ')='_';
triggers = p_events*4+events;

%%%% end screen
w = Screen('OpenWindow',screenNumber, gray);
Screen('Flip', w);
Screen('FillRect', w,gray);
Screen('TextSize', w, 60);
uiwait(helpdlg('Stimulus is done'));

ListenChar(0); % end suppressing of key presses

save(strcat('/homes/7/jwt30/Documents/MATLAB/matFiles/matFiles/',subjectID,'_',dateString,'_Results','.mat'),...
    'p_events','reactionTime','correctTrials','shape_events','events','triggers');

compute_rt_062017(events, reactionTime, p_events, correctTrials);
print(gcf,'-dpng',strcat('/homes/7/jwt30/Documents/MATLAB/matFiles/matFiles/',subjectID,'_',dateString,'_Results','.png'));

DrawFormattedText(w, 'You can relax now!', 'center','center', white);
Screen('Flip', w);
WaitSecs(2);KbWait


% Screen('closeall');



end


