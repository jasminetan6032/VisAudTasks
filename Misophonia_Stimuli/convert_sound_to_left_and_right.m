%create list of sounds to convert
list_misophones = {'breathing','chewing','joint_cracking','lip_smacking','nail_clipping','slurping','snoring', 'sniffing', 'swallowing','throat_clearing'};

cd /local_mount/space/hypatia/2/users/Jasmine/github/VisAudTasks/Misophonia_Stimuli

for sound_i = 1:length(list_misophones)

    [sound, Fs] = audioread([list_misophones{sound_i} '.wav']);
    
    %Some sounds are stereo (2 columns), some are mono. Record which is
    %which. 
    checkdims{sound_i,1} = size(sound);
    
    %Convert to play to only one ear. It needs to be stereo (2 columns,
    %corresponding to left and right) and you replace the column that
    %corresponds to the side you want to be silent with zero. 

    %Play only to left ear - sound data in column 1, column 2 empty 
    sound_L = sound;
    sound_L(:,2) = 0;
    checkdims{sound_i,2} = sound_L(1,:);
    
    filename = [list_misophones{sound_i} 'L.wav'];

    audiowrite(filename,sound_L,Fs)

    %Play only to right ear - column 1 empty, sound data in column 2
    if checkdims{sound_i}(2) == 2
        sound_R = sound;
        sound_R(:,1) = 0;
    elseif checkdims{sound_i}(2) == 1
        sound_R = sound;
        sound_R(:,2) = sound;
        sound_R(:,1) = 0;
    end
    checkdims{sound_i,3} = sound_R(1,:);
    filename = [list_misophones{sound_i} 'R.wav'];

    audiowrite(filename,sound_R,Fs)

    %empty previous variables
    sound = [];
    sound_L = [];
    sound_R = [];
    Fs = [];
    filename = [];

end