%create list of stereo sounds to convert to mono for online presentation
%of sound
list_novels = {'bangL','barkL','chainL','clingL','clongL','dtmfL','honkL', 'raygunL'};
list_misophones = {'breathing','chewing','joint_cracking','lip_smacking','nail_clipping','slurping','snoring', 'sniffing', 'swallowing','throat_clearing'};
list_beeps = {'harm-dev-L-50ms', '1500-Hz-std-L-50ms','800-Hz-std-L-50ms'};
list_check_sounds = {'breathing1','breathingL','joint_crackingL','jointcrack5'};

cd /local_mount/space/hypatia/2/users/Jasmine/github/VisAudTasks/stereostimuli

sound_type = 'misophones';
list_sounds = eval(['list_' sound_type]);

for sound_i = 1:length(list_sounds)

    [sound, Fs] = audioread([list_sounds{sound_i} '.wav']);%add an L or R for misophones 
    
    %Calculate and save length of sounds
    sounds{sound_i,1} = list_sounds{sound_i};
    sounds{sound_i,2} = Fs; %It's the same for the R sound too.
    sounds{sound_i,3} = length(sound)/Fs;

end

sounds{sound_i + 2,1} = 'standard deviation';
sounds{sound_i + 2,2} = std([sounds{:,3}]);
sounds{sound_i + 3,1} = 'mean';
sounds{sound_i + 3,2} = mean([sounds{:,3}]);
sounds{sound_i + 4,1} = 'median';
sounds{sound_i + 4,2} = median([sounds{:,3}]);


length_sounds = cell2table(sounds);
length_sounds.Properties.VariableNames(1) = "sound_type";
length_sounds.Properties.VariableNames(2) = "frequency";
length_sounds.Properties.VariableNames(3) = "length of sound (s)";


filename = ['length_of_' sound_type '.xlsx'];
writetable(length_sounds,filename,'Sheet',1,'Range','A1')

sounds = [];
length_sounds = [];