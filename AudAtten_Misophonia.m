function AudAtten_Misophonia(use_trigs, Volume_multiplier, nEvents, nRepeats, wait_time,training_flag)
%AudAtten_Misophonia(1,1,18,1,2.5,0)

% Volume_multiplier - makes the Deviant easier to detect. 1.5 makes it
% quite easy. 1 is hardest. 1.2 is a good training volume.

% nEvents is the number of events per block that will be presented to each
% ear (i.e. total number of events per block is nEvents*2)

% nRepeats is how many blocks there are PER EAR PER STD CONDITION (so,
% minimum blocks is 4 (nRepeats input = 1), one std per ear, each ear attended twice, once with
% each std type.

% wait_time is how long to wait in seconds when showing the attended year arrows at the
% beginning of each block

% training_flag: for training subjects. Does only ONE block. The training
% flag is the block number, with the following specifics:
% training_flag=0  >>> regular run, no training.
% training_flag=1/2/3/4  >>>> run ONLY attended ear, case number 1/2/3/4
%     respectively (corresponds to trigger numbers - see below
% training_flag=-1/-2/-3/-4  >>>> run BOTH attended and unattended ear, case number 1/2/3/4
%     respectively (corresponds to trigger numbers - see below. Different
%     from real run because it will still run only the specified block.


Percent_Distractors=0.05;

% Percent_Distractors = % (fraction) of "fake" targets on the attended ear, as a
% function of standards in that ear.

% Setting up triggers:

%       Attended Right (odd triggers):
% Standard 1500Hz in right ear:  1
% Standard 800Hz in right ear: 3
% Target (devR) in right ear:   11 /13  (=std+10)

% Standard 800Hz in left ear:  5
% Standard 1500Hz in left ear:   7
% Target (devL) in left ear (to be ignored): 35 /37 (std + 34)
% Novel in left ear: 25 / 27 (std+24)

%       Attended Left (even triggers):
% Standard 1500Hz in left ear: 2
% Standard 800Hz in left ear: 4
% Target (devL) in left ear:  12 / 14 (std+10)

% Standard 800Hz in right ear:  6
% Standard 1500Hz in right ear: 8
% Target (devR) in right ear (to be ignored): 36 / 38  (std + 34)
% Novel in right ear: 26 / 28  (std +24)



subjectID = input('Enter the subject name:','s');

list_misophones = {'breathing','chewing','joint_cracking','lip_smacking','nail_clipping','slurping','snoring', 'swallowing','throat_clearing'};

[indx,tf] = listdlg('ListString',list_misophones);
misophone = list_misophones{indx};

uiwait(helpdlg('Check: volume settings, audio cable connected???','Triggers box on USB?'));

if training_flag
    uiwait(helpdlg('SET LAPTOP VOLUME AT 50% !!!','MAKE SURE'));
else
    uiwait(helpdlg('SET LAPTOP VOLUME AT 100% !!!','MAKE SURE'));
end
% uiwait(helpdlg('that all volumes are at the correct settings (70db, 12 on crown, 8 on volume)','MAKE SURE'));
% uiwait(helpdlg('Laptop Volume is at max"','MAKE SURE'));
% uiwait(helpdlg('that the audio cable is connected to the laptop','MAKE SURE'));

if nargin < 6
    training_flag=0;
end;


if nargin < 5
    wait_time=5;
end;

if nargin < 4
    nRepeats=4;
end;

if nargin < 3
    nEvents=20;
end;

if nargin < 2
    Volume_multiplier=1;
end;

if nargin < 1
    use_trigs=1;
end;

% This is in order to write a file with the TRIGGERS
global cnt_trials;
cnt_trials=0;

global Triggers_trace
Triggers_trace=zeros(nEvents*nRepeats*2*4,1);

global Response_trace
Response_trace=zeros(nEvents*nRepeats*2*4,2);


KbName('UnifyKeyNames');


nrchannels = 2;
freq = 44100;
InitializePsychSound;
PsychPortAudio('Verbosity',0);
global phandle
pahandle = PsychPortAudio('Open');
PsychPortAudio('LatencyBias',pahandle);

% sets up initial parameters - different for training and not training
if training_flag
  training_event=abs(training_flag);
  events = ones(1,nEvents)*training_event;
  nTrials = size(events,1);   
  nRepeats=1;
else
  events = [ones(1,nEvents);ones(1,nEvents)*2;ones(1,nEvents)*3;ones(1,nEvents)*4];
  events=repmat(events,[nRepeats,1]);
  events=events(randperm(size(events,1)),:);
  nTrials=size(events,1);
end

if use_trigs
    di = DaqDeviceIndex;
    DaqDConfigPort(di,0,0);
    DaqDOut(di,0,0);
else
    di=0;
end


[misoL, fsmisoL] = audioread(['./stereostimuli/' misophone 'L.wav']);
[misoR, fsmisoR] = audioread(['./stereostimuli/' misophone 'R.wav']);

[devL, fsdevL] = audioread('./stereostimuli/harm-dev-L-50ms.wav');
[devR, fsdevR] = audioread('./stereostimuli/harm-dev-R-50ms.wav');


[stdL1500, fsstdL1500] = audioread('./stereostimuli/1500-Hz-std-L-50ms.wav');
[stdR1500, fsstdR1500] = audioread('./stereostimuli/1500-Hz-std-R-50ms.wav');

[stdL800, fsstdL800] = audioread('./stereostimuli/800-Hz-std-L-50ms.wav');
[stdR800, fsstdR800] = audioread('./stereostimuli/800-Hz-std-R-50ms.wav');

[nL1, fsnL1] = audioread('./stereostimuli/bangL.wav');
[nL2, fsnL2] = audioread('./stereostimuli/barkL.wav');
[nL3, fsnL3] = audioread('./stereostimuli/chainL.wav');
[nL4, fsnL4] = audioread('./stereostimuli/clingL.wav');
[nL5, fsnL5] = audioread('./stereostimuli/clongL.wav');
[nL6, fsnL6] = audioread('./stereostimuli/dtmfL.wav');
[nL7, fsnL7] = audioread('./stereostimuli/honkL.wav');
[nL8, fsnL8] = audioread('./stereostimuli/raygunL.wav');


[nR1, fsnR1] = audioread('./stereostimuli/bangR.wav');
[nR2, fsnR2] = audioread('./stereostimuli/barkR.wav');
[nR3, fsnR3] = audioread('./stereostimuli/chainR.wav');
[nR4, fsnR4] = audioread('./stereostimuli/clingR.wav');
[nR5, fsnR5] = audioread('./stereostimuli/clongR.wav');
[nR6, fsnR6] = audioread('./stereostimuli/dtmfR.wav');
[nR7, fsnR7] = audioread('./stereostimuli/honkR.wav');
[nR8, fsnR8] = audioread('./stereostimuli/raygunR.wav');

devL = Volume_multiplier*devL';
devR = Volume_multiplier*devR';

misoL = misoL';
misoR = misoR';

stdL1500 = stdL1500';
stdR1500 = stdR1500';

stdL800 = stdL800';
stdR800 = stdR800';

nL1 = nL1';
nL2 = nL2';
nL3 = nL3';
nL4 = nL4';
nL5 = nL5';
nL6 = nL6';
nL7 = nL7';
nL8 = nL8';

nR1 = nR1';
nR2 = nR2';
nR3 = nR3';
nR4 = nR4';
nR5 = nR5';
nR6 = nR6';
nR7 = nR7';
nR8 = nR8';

maxpriority = 9;
oldpriority = Priority(maxpriority);

AssertOpenGL;
Screen('Preference','Verbosity',0);
Screen('Preference','VisualDebuglevel',0);
screenNumber=max(Screen('Screens'));
Screen('Preference', 'SkipSyncTests', 1);

white=WhiteIndex(screenNumber);
black=BlackIndex(screenNumber);

gray=round((white+black)/2);
if gray == white
    gray=white / 2;
end

keyPressed = zeros(nTrials,nEvents)*NaN;
kbresponsetime = zeros(nTrials,nEvents)*NaN;
allevents = zeros(nTrials,nEvents)*NaN;

target_flag=0; %%%This will change to 1 if target is played, and then we know to check keyboard.




w = Screen('OpenWindow',screenNumber, gray);
Screen('Flip', w);
Screen('FillRect', w,gray);
Screen('TextSize', w, 60);
uiwait(helpdlg('Stimulus is Ready'));
DrawFormattedText(w, 'We are about to begin...', 'center','center', white);
Screen('Flip', w);
% WaitSecs(2);KbWait
uiwait(helpdlg('CLICK TO START!!!'));


ListenChar(2); %initiates listening to the keyboard for "getchar", "2" suppresses character output to active window


start_time=tic;

%%% EXPERIMENTER NEEDS TO PRESS BUTTON HERE!!!!

Screen('FillRect', w,gray);
Screen('TextSize', w, 80);
DrawFormattedText(w, '+', 'center','center', white);
Screen('Flip', w);
WaitSecs(1);
trial=0;
for i=1:nTrials
    
    flag=1;
    
    % this flags something...?? 
    
    for i1 = 1:nEvents
        %  KbQueueCreate;
        if i1==1
            if events(i,i1) == 1 || events(i,i1) == 3
                Screen('FillRect', w,gray);
                Screen('TextSize', w, 80);
                DrawFormattedText(w, '       +   >>', 'center','center', white);
                Screen('Flip', w);
                WaitSecs(wait_time);
                %%% Odd event categories 1, 3, are "attend right")
            elseif events(i,i1) == 2 || events(i,i1) == 4
                Screen('FillRect', w,gray);
                Screen('TextSize', w, 80);
                DrawFormattedText(w, '<<   +       ', 'center','center', white);
                Screen('Flip', w);
                WaitSecs(wait_time);
                %%% Even event categories 2, 4, are "attend left")
            end
            Screen('FillRect', w,gray);
            Screen('TextSize', w, 80);
            DrawFormattedText(w, '+', 'center','center', white);
            Screen('Flip', w);
            WaitSecs(1);
        end
        
        %%%%% HERE, AT THE BEGINNING OF EACH EVENT, WE CHECK IF THE PRIOR
        %%%%% TRIAL WAS A TARGET EVENT, AND IF YES, SEE IF THERE WAS A
        %%%%% KEYBOARD ENTRY!!  IF THERE WAS, THEN WE GET THE INFO USING
        %%%%% GETCHAR, AND RESET
        
        if target_flag == 1 %if prior event was a target event
            check_keyboard(onset_time,side_flag);  %check for responses and record the results
        end
        FlushEvents; 
        target_flag=0; % reset target_flag
        % >>>  clear the queue for the next char press before each event, and do it 
        % outside if statement so that if key was pressed for non-target it is not an issue.

           
        if flag
            nstandard = randi([3,7],1);
            if nstandard > 3
                nnovel= randi([2,nstandard-2],1);
%                 x = setdiff(3:nstandard, nnovel);
%                 nmisophonic = x(randi(numel(x)));
            else
                nnovel= 2;
            end
            count=1;
            flag=0;
        end
        
        
  %%%%%%%%%%%%%%%%%%%%%%%%%  Here start the 4 parallel cases. Each run
  %%%%%%%%%%%%%%%%%%%%%%%%%  through the loop "trial" will use the same
  %%%%%%%%%%%%%%%%%%%%%%%%%  case through nEvents (number of events per
  %%%%%%%%%%%%%%%%%%%%%%%%%  trial)
  
  
        if events(i,i1)==1
            
            if count <= nstandard
                flag1=1;
                if round(randn(1))
                    play_sound(stdR1500,fsstdR1500);
                    send_trigger(di, events(i,i1), use_trigs);
                    disp(['stdR1500 attended Right and Trigger Number is: ' num2str(events(i,i1))])
                    WaitSecs(.99+.3*rand(1));
                    flag1=0;
                end
                if count == nnovel
                    if round(randn(1))
                        if training_flag < 0.5
                            play_sound(misoL,fsmisoL);
                            send_trigger(di, events(i,i1)+44, use_trigs);
                            disp(['Misophonic sound on LEFT, attended Right and Trigger Number is: ' num2str(events(i,i1)+44)])
                        end
                    else
                        typeNovel = randi([1,8],1);
                        allevents(i,i1)=events(i,i1);
                        if training_flag < 0.5
                            play_sound(eval(['nL' num2str(typeNovel)]),eval(['fsnL' num2str(typeNovel)]));
                            send_trigger(di, events(i,i1)+24, use_trigs);
                            disp(['Novel on LEFT, attended Right and Trigger Number is: ' num2str(events(i,i1)+24)])
                        end
                    end
                else
                    tmp=rand(1);
                    if tmp > Percent_Distractors
                        if training_flag < 0.5
                           play_sound(stdL800,fsstdL800);
                           send_trigger(di, events(i,i1) + 4, use_trigs);
                           disp(['stdL800 on Left, attended Right, and Trigger Number is: ' num2str(events(i,i1)+4)])
                        end
                    else
                        if training_flag < 0.5
                           play_sound(devL, fsdevL);
                           send_trigger(di, events(i,i1) + 34, use_trigs);
                           disp(['TARGET (devL) on Left, attended Right, and Trigger Number is: ' num2str(events(i,i1)+34)])
                        end
                    end
                    allevents(i,i1)=events(i,i1);
                end
                WaitSecs(.99+.3*rand(1));
                if flag1
                    play_sound(stdR1500,fsstdR1500);
                    send_trigger(di, events(i,i1), use_trigs);
                    disp(['stdR1500 on Right, attended Right, and Trigger Number is: ' num2str(events(i,i1))])
                    WaitSecs(.99+.3*rand(1));
                end
                
            else
                flag1=1;
                if round(randn(1))
                    if training_flag < 0.5
                       play_sound(stdL800, fsstdL800);
                       send_trigger(di, events(i,i1) +4, use_trigs);
                       disp(['stdL800 on Left, attended Right, and Trigger Number is: ' num2str(events(i,i1)+4)])
                    end
                    WaitSecs(.99+.3*rand(1));
                    flag1=0;
                end
                
                % KbQueueStart;
                onset_time=tic;
                side_flag='R';
                target_flag=1;  % indicate a target was played, used to decide if to check keyboard in next loop run

                play_sound(devR, fsdevR);
                send_trigger(di, events(i,i1) + 10, use_trigs);
                disp(['****TARGET**** on Right, attended Right, and Trigger Number is: ' num2str(events(i,i1)+10)])

                WaitSecs(.99+.3*rand(1));
                % check_keyboard(onset_time,side_flag);
                
                if flag1
                    if training_flag < 0.5
                       play_sound(stdL800, fsstdL800);
                       send_trigger(di, events(i,i1) +4, use_trigs);
                       disp(['stdL800 on left, attended Right, and Trigger Number is: ' num2str(events(i,i1)+4)])
                    end
                    WaitSecs(.99+.3*rand(1));
                end
                flag=1;
                allevents(i,i1)=events(i,i1)+5;
            end
            
            
            
        elseif events(i,i1)==2
            if count <= nstandard
                flag1=1;
                if round(randn(1))
                    play_sound(stdL1500,fsstdL1500);
                    send_trigger(di, events(i,i1), use_trigs);
                    disp(['stdL1500 on left, attended Left, and Trigger Number is: ' num2str(events(i,i1))])
                    WaitSecs(.99+.3*rand(1));
                    flag1=0;
                end

                if count == nnovel
                    if round(randn(1))
                        if training_flag < 0.5
                            play_sound(misoR,fsmisoR);
                            send_trigger(di, events(i,i1)+44, use_trigs);
                            disp(['Misophonic sound on RIGHT, attended Left and Trigger Number is: ' num2str(events(i,i1)+44)])
                        end
                    else
                        typeNovel = randi([1,8],1);
                        if training_flag < 0.5
                            play_sound(eval(['nR' num2str(typeNovel)]),eval(['fsnR' num2str(typeNovel)]));
                            allevents(i,i1)=events(i,i1)+6;
                            send_trigger(di, events(i,i1)+24, use_trigs);
                            disp(['Novel on right, attended Left, and Trigger Number is: ' num2str(events(i,i1)+24)])
                        end
                    end
                else
                    tmp=rand(1);
                    if tmp > Percent_Distractors
                        if training_flag < 0.5
                           play_sound(stdR800,fsstdR800);
                           send_trigger(di, events(i,i1)+4, use_trigs);
                           disp(['stdR800 on right, attended Left, and Trigger Number is: ' num2str(events(i,i1)+4)])
                        end
                    else
                        if training_flag < 0.5
                           play_sound(devR, fsdevR);
                           send_trigger(di, events(i,i1) + 34, use_trigs);
                           disp(['TARGET on Right, Ignore, Attended Left, and Trigger Number is: ' num2str(events(i,i1)+34)])
                        end
                    end
                    
                    allevents(i,i1)=events(i,i1);
                end
                WaitSecs(.99+.3*rand(1));
                if flag1
                    play_sound(stdL1500,fsstdL1500);
                    send_trigger(di, events(i,i1), use_trigs);
                    disp(['stdL1500 on left, attended Right, and Trigger Number is: ' num2str(events(i,i1))])
                    WaitSecs(.99+.3*rand(1));
                end
                
            else
                flag1=1;
                if round(randn(1))
                    if training_flag < 0.5
                       play_sound(stdR800, fsstdR800);
                       send_trigger(di, events(i,i1)+4, use_trigs);
                       disp(['stdR800 on right, attended Left, and Trigger Number is: ' num2str(events(i,i1)+4)])
                    end
                    WaitSecs(.99+.3*rand(1));
                    flag1=0;
                end
                
                % KbQueueStart;
                
                onset_time=tic;
                side_flag='L';
                target_flag=1;  % indicate a target was played, used to decide if to check keyboard in next loop run

                play_sound(devL, fsdevL);
                send_trigger(di, events(i,i1)+10, use_trigs);
                disp(['****TARGET**** on left, attended Left, and Trigger Number is: ' num2str(events(i,i1)+10)])
                WaitSecs(.99+.3*rand(1));
                % check_keyboard(onset_time,side_flag);

                
                if flag1
                    if training_flag < 0.5
                       play_sound(stdR800, fsstdR800);
                       send_trigger(di, events(i,i1)+4, use_trigs);
                       disp(['stdR800 on right, attended left, and Trigger Number is: ' num2str(events(i,i1)+4)])
                    end
                    WaitSecs(.99+.3*rand(1));
                end
                flag=1;
                allevents(i,i1)=events(i,i1)+7;
            end
            
            
            
            
        elseif events(i,i1)==3
            if count <= nstandard
                flag1=1;
                if round(randn(1))
                    play_sound(stdR800,fsstdR800);
                    send_trigger(di, events(i,i1), use_trigs);
                    disp(['stdR800 on Right, attended Right, and Trigger Number is: ' num2str(events(i,i1))])
                    WaitSecs(.99+.3*rand(1));
                    flag1=0;
                end

                if count == nnovel
                    if round(randn(1))
                        if training_flag < 0.5
                            play_sound(misoL,fsmisoL);
                            send_trigger(di, events(i,i1)+44, use_trigs);
                            disp(['Misophonic sound on LEFT, attended Right and Trigger Number is: ' num2str(events(i,i1)+44)])
                        end
                    else
                        typeNovel = randi([1,8],1);
                        if training_flag < 0.5
                            play_sound(eval(['nL' num2str(typeNovel)]),eval(['fsnL' num2str(typeNovel)]))
                            allevents(i,i1)=events(i,i1)+8;
                            send_trigger(di, events(i,i1)+24, use_trigs);
                            disp(['Novel on Left, attended Right, and Trigger Number is: ' num2str(events(i,i1)+24)])
                        end
                    end
                else
                    tmp=rand(1);
                    if  tmp > Percent_Distractors
                        if training_flag < 0.5
                           play_sound(stdL1500,fsstdL1500);
                           send_trigger(di, events(i,i1)+4, use_trigs);
                           disp(['stdL1500 on left, attended Right, and Trigger Number is: ' num2str(events(i,i1)+4)])
                        end
                    else
                        if training_flag < 0.5
                           play_sound(devL, fsdevL);
                           send_trigger(di, events(i,i1) + 34, use_trigs);
                           disp(['TARGET on left, IGNORE, attended Right, and Trigger Number is: ' num2str(events(i,i1)+34)])
                        end
                    end
                    
                    allevents(i,i1)=events(i,i1);
                end
                WaitSecs(.99+.3*rand(1));
                if flag1
                    play_sound(stdR800,fsstdR800);
                    send_trigger(di, events(i,i1), use_trigs);
                    disp(['stdR800 on Right, attended Right, and Trigger Number is: ' num2str(events(i,i1))])
                    WaitSecs(.99+.3*rand(1));
                end
                
            else
                flag1=1;
                if round(randn(1))
                    if training_flag < 0.5
                        play_sound(stdL1500, fsstdL1500);
                        send_trigger(di, events(i,i1)+4, use_trigs);
                        disp(['stdL1500 on Left, attended Right, and Trigger Number is: ' num2str(events(i,i1)+4)])
                    end
                    WaitSecs(.99+.3*rand(1));
                    flag1=0;
                end
                
                % KbQueueStart;
                onset_time=tic;
                side_flag='R';
                target_flag=1;  % indicate a target was played, used to decide if to check keyboard in next loop run

                play_sound(devR, fsdevR);
                send_trigger(di, events(i,i1)+10, use_trigs);
                disp(['****TARGET**** on Right, attended Right, and Trigger Number is: ' num2str(events(i,i1)+10)])
                target_flag=1;  % indicate a target was played, used to decide if to check keyboard in next loop run
                WaitSecs(.99+.3*rand(1));
 %               [keyPressed(i,i1), kbresponsetime(i,i1)]=check_keyboard(t0);
                % check_keyboard(onset_time,side_flag);

                if flag1
                    if training_flag < 0.5
                       play_sound(stdL1500, fsstdL1500);
                       send_trigger(di, events(i,i1)+4, use_trigs);
                       disp(['Std1500 on left, attended right, and Trigger Number is: ' num2str(events(i,i1)+4)])
                    end
                    WaitSecs(.99+.3*rand(1));
                end
                flag=1;
                allevents(i,i1)=events(i,i1)+9;
            end
            
            
        elseif events(i,i1)==4
            if count <= nstandard
                flag1=1;
                if round(randn(1))
                    play_sound(stdL800,fsstdL800);
                    send_trigger(di, events(i,i1), use_trigs);
                    disp(['stdL800 on Left, attended Left, and Trigger Number is: ' num2str(events(i,i1))])
                    WaitSecs(.99+.3*rand(1));
                    flag1=0;
                end

                if count == nnovel
                    if round(randn(1))
                        if training_flag < 0.5
                            play_sound(misoR,fsmisoR);
                            send_trigger(di, events(i,i1)+44, use_trigs);
                            disp(['Misophonic sound on RIGHT, attended Left and Trigger Number is: ' num2str(events(i,i1)+44)])
                        end
                    else
                        typeNovel = randi([1,8],1);
                        if training_flag < 0.5
                            play_sound(eval(['nR' num2str(typeNovel)]),eval(['fsnR' num2str(typeNovel)]))
                            allevents(i,i1)=events(i,i1)+10;
                            send_trigger(di, events(i,i1)+24, use_trigs);
                            disp(['Novel on Right, attended Left, and Trigger Number is: ' num2str(events(i,i1)+24)])
                        end
                    end
                else
                    tmp=rand(1);
                    if tmp > Percent_Distractors
                        if training_flag < 0.5
                           play_sound(stdR1500,fsstdR1500);
                           send_trigger(di, events(i,i1)+4, use_trigs);
                           disp(['stdR1500 on Right, attended Left, and Trigger Number is: ' num2str(events(i,i1)+4)])
                        end
                    else
                        if training_flag < 0.5
                           play_sound(devR, fsdevR);
                           send_trigger(di, events(i,i1) + 34, use_trigs);
                           disp(['TARGET on Right, attended LEFT, IGNORE, and Trigger Number is: ' num2str(events(i,i1)+34)])
                        end
                    end
                    
                    allevents(i,i1)=events(i,i1);
                end
                WaitSecs(.99+.3*rand(1));
                if flag1
                    play_sound(stdL800,fsstdL800); 
                    send_trigger(di, events(i,i1), use_trigs);
                    disp(['stdL800 on Left, attended Left, and Trigger Number is: ' num2str(events(i,i1))])
                    WaitSecs(.99+.3*rand(1));
                end
                
            else
                flag1=1;
                if round(randn(1))
                    if training_flag < 0.5
                       play_sound(stdR1500, fsstdR1500);
                       send_trigger(di, events(i,i1)+4, use_trigs);
                       disp(['stdR1500 on Right, attended Left, and Trigger Number is: ' num2str(events(i,i1)+4)])
                    end
                    WaitSecs(.99+.3*rand(1));
                    flag1=0;
                end
                
                % KbQueueStart;
                
                onset_time=tic;
                side_flag='L';
                target_flag=1;  % indicate a target was played, used to decide if to check keyboard in next loop run

                play_sound(devL, fsdevL);
                send_trigger(di, events(i,i1)+10, use_trigs);
                disp(['****TARGET**** on LEFT, attended LEFT, and Trigger Number is: ' num2str(events(i,i1)+10)])

                WaitSecs(.99+.3*rand(1));
%                [keyPressed(i,i1), kbresponsetime(i,i1)]=check_keyboard(t0);
               % check_keyboard(onset_time,side_flag);

                                
                if flag1
                    if training_flag < 0.5
                       play_sound(stdR1500, fsstdR1500);
                       send_trigger(di, events(i,i1)+4, use_trigs);
                       disp(['stdR1500 on Right, attended Left, and Trigger Number is: ' num2str(events(i,i1)+4)])
                    end
                    WaitSecs(.99+.3*rand(1));
                end
                flag=1;
                allevents(i,i1)=events(i,i1)+11;
            end
            
            
        end
        
        count = count+1;
        trial=trial+1;
        fprintf(1, '................Completed %d/%d trials in the attended ear \n', trial, nTrials*nEvents);
    end
    
    WaitSecs(1 + .2*rand(1));
end
dateString=datestr(now);
dateString(dateString==' ')='_';

% save(strcat('/home/transcend/Documents/Stimuli/R01-Feedforward-Feedback/2008-cueshift/MatFiles/',subjectID,'_',dateString,'_Results','.mat'),...
%    'events','Triggers_trace','Response_trace','keyPressed','kbresponsetime','allevents','Volume_multiplier','detected','mrt');

Priority(oldpriority);
Screen('CloseAll');
kbresponsetime=kbresponsetime(:);
allevents=allevents(:);
detected = sum(~isnan(kbresponsetime))/sum(ismember(allevents,[15,9,6,12]));
mrt = median(kbresponsetime(~isnan(kbresponsetime))*1000);
fprintf(1, '\n \n \n Percent Target Detected =  %3.1f%% \n', detected*100);
fprintf(1, 'Mean Response Time =  %4.1f ms \n', mrt);

fprintf(1, '# Std on Right Attend Right =  %4d \n', length(find(Triggers_trace==1))+length(find(Triggers_trace==3)));
fprintf(1, '# Std on Left Attend Left =  %4d \n', length(find(Triggers_trace==2))+length(find(Triggers_trace==4)));
fprintf(1, '# Std on Right Attend Left =  %4d \n', length(find(Triggers_trace==5))+length(find(Triggers_trace==7)));
fprintf(1, '# Std on Left Attend Right =  %4d \n', length(find(Triggers_trace==6))+length(find(Triggers_trace==8)));
fprintf(1, '# Targets on Right, attend Right =  %4d \n', length(find(Triggers_trace==11))+length(find(Triggers_trace==13)));
fprintf(1, '# Targets on Left, attend Left =  %4d \n', length(find(Triggers_trace==12))+length(find(Triggers_trace==14)));
fprintf(1, '# Novels on right, attend Left =  %4d \n', length(find(Triggers_trace==25))+length(find(Triggers_trace==27)));
fprintf(1, '# Novels on left, attend right =  %4d \n', length(find(Triggers_trace==26))+length(find(Triggers_trace==28)));
fprintf(1, '# Targets on left, attend right =  %4d \n', length(find(Triggers_trace==36))+length(find(Triggers_trace==38)));
fprintf(1, '# Targets on right, attend left =  %4d \n', length(find(Triggers_trace==35))+length(find(Triggers_trace==37)));
fprintf(1, '# Misophonic sound on right, attend Left =  %4d \n', length(find(Triggers_trace==45))+length(find(Triggers_trace==47)));
fprintf(1, '# Misophonic sound on left, attend right =  %4d \n', length(find(Triggers_trace==46))+length(find(Triggers_trace==48)));




% figure;hist(kbresponsetime(~isnan(kbresponsetime))*1000);
% xlabel('Reaction Time (ms)','fontsize',14)
% ylabel('Frequency','fontsize',14)
% title(['Mean Reaction Times = ' num2str(median(kbresponsetime(~isnan(kbresponsetime))*1000))],'fontsize',14)
% set(gca,'fontsize',14);
% print(gcf,'-dpng',strcat('/home/transcend/Documents/Stimuli/R01-Feedforward-Feedback/2008-cueshift/MatFiles/',subjectID,'_',dateString,'_results','.png'))

save(strcat('/home/transcend/Documents/Stimuli/R01-Feedforward-Feedback/2008-cueshift/MatFiles/',subjectID,'_',dateString,'_Results','.mat'),...
    'events','Triggers_trace','Response_trace','keyPressed','kbresponsetime','allevents','Volume_multiplier','detected','mrt','Response_trace','nEvents','nRepeats','training_flag');


    function play_sound(sound_data, sfreq)
        s = inputname(1);
        %disp(['Stimulu is ''' s '''.'])
        %pahandle = PsychPortAudio('Open', [], [], 0, sfreq, 2);
        %PsychPortAudio('Volume',pahandle,.75);
        InitializePsychSound;
        %pahandle = PsychPortAudio('Open');
        PsychPortAudio('FillBuffer', pahandle, sound_data);
        PsychPortAudio('Start', pahandle, 1, 0, 1);
        PsychPortAudio('Stop',pahandle,1,1);
    end

    function send_trigger(di, event, use_trigs)
        if use_trigs
            cnt_trials=cnt_trials+1;
            DaqDOut(di,0,event);  %send trigger
            DaqDOut(di,0,0);  %clear trig
            %disp(['Trigger Number is: ' num2str(event)])
            Triggers_trace(cnt_trials,1)=event; 
        end
    end

    function check_keyboard(onset_time,side_flag) 
        
        [avail,numChars]=CharAvail; %% Check if there was a key pressed since last flush
        
        if avail % a key was pressed!
                [ch,when]=GetChar; % Get which key it was
                %% I cannot get reaction time to work...
%                 when=uint64(when.secs)*1000000;
%                 tempo=(when-onset_time)/100000;
%                 class(tempo);
%                 tempo2=double(tempo);
%                 reactionTime=round(tempo2,3); % REALLY not sure about this one...
                reactionTime=0.999;
        %       side_flag

                %%%% IN RESPONSE PADS, 11:14 correspond to right side, and 16:19 to
                %%%% left side

                %%% When using a keyboad, 1,2,3,4 correspond to 11:14, but they're
                %%% on the left, and vice versa for the other side, so need to
                %%% change flags for practice OR come up with different mapping or
                %%% something...

                %%% WE ADDED KEY CODE = 39 for key "a" for LEFT SIDE
                %%% WE ADDED KEY CODE = 47 for key "l" for RIGHT SIDE

                cnt_trials
                %if find(keyCode==1)==11 || find(keyCode==1)==12 || find(keyCode==1)==13|| find(keyCode==1)==14
                %if keyCode==11 || keyCode==12 || keyCode==13|| keyCode==14 || keyCode==47
                
                if ch == '1' || ch == '2' || ch == '3' || ch == '4' || ch == 'p'
                    if side_flag=='R'
                        Response_trace(cnt_trials,1)=1;
                        Response_trace(cnt_trials,2)= reactionTime;
                    elseif side_flag=='L'
                        Response_trace(cnt_trials,1)=-1;
                        Response_trace(cnt_trials,2)= reactionTime;
                    end
                % elseif find(keyCode==1)==16 || find(keyCode==1)==17 || find(keyCode==1)==18 || find(keyCode==1)==19
                %elseif keyCode==16 || keyCode==17 || keyCode==18 || keyCode==19 || keyCode==39
                elseif ch == '6' || ch == '7' || ch == '8' || ch == '9' || ch == 'q'
                     if side_flag=='L'
                        Response_trace(cnt_trials,1)=1;
                        Response_trace(cnt_trials,2)= reactionTime;
                    elseif side_flag=='R'
                        Response_trace(cnt_trials,1)=-1;
                        Response_trace(cnt_trials,2)= reactionTime;
                     end
                else
                    Response_trace(cnt_trials,1)=99;
                    disp(['        >>>>>>>>  Target not missed, but unexpected key pressed...........'])
                end
                fprintf(1, '      >>>>>>  Target Trial:: Key Pressed =  %d  \n', Response_trace(cnt_trials,1));
                fprintf(1, '      >>>>>>  Target Trial:: Reaction Time =  %3.3f  \n', Response_trace(cnt_trials,2));
        else
                Response_trace(cnt_trials,1)=1000;
                disp(['        >>>>>>>>  TARGET WAS MISSED...........'])

        end
    end

toc(start_time)

%      correctTrials(i) = sign(selected_event(traget_location,1))==flag1;
%      disp(['trial type and Trigger Number is: ' num2str((p_events(i)*4) + events(i))])      
%     disp(['trial correct (1/0): ' num2str(correctTrials(i))])
%     disp(['reaction time is: ' num2str(reactionTime(i)*1000)])

disp(['Number of correct target detections: ' num2str(length(find(Response_trace(:,1)==1)))])
disp(['Number of incorrect target detections (clicked on wrong side): ' num2str(length(find(Response_trace(:,1)==-1)))])
disp(['Number of not L or R defined key presses detections: ' num2str(length(find(Response_trace(:,1)==99)))])
disp(['Number of missed targets: ' num2str(length(find(Response_trace(:,1)==1000)))])

w = Screen('OpenWindow',screenNumber, gray);
Screen('Flip', w);
Screen('FillRect', w,gray);
Screen('TextSize', w, 60);
uiwait(helpdlg('Stimulus is done'));
DrawFormattedText(w, 'You can relax now!', 'center','center', white);
Screen('Flip', w);
WaitSecs(2);KbWait


PsychPortAudio('Close',pahandle);
  
ListenChar(0);

  
Response_trace;

end