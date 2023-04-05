%create list of stereo sounds to convert to mono for online presentation
%of sound
list_novels = {'bang','bark','chain','cling','clong','dtmf','honk', 'raygun'};
save_file = '/local_mount/space/hypatia/2/users/Jasmine/github/VisAudTasks/Online_Novels/';

cd /local_mount/space/hypatia/2/users/Jasmine/github/VisAudTasks/stereostimuli

for sound_i = 1:length(list_novels)

    [sound, Fs] = audioread([list_novels{sound_i} 'L.wav']);
    
    %All sounds will be on the left 
    checkdims{sound_i,1} = size(sound);
    
    %Convert to play to both ears. Double sound other column
    sound_online = sound;
    sound_online(:,2) = sound(:,1);
    
    filename = [save_file list_novels{sound_i} '_online.wav'];

    audiowrite(filename,sound_online,Fs)

    %empty previous variables
    sound = [];
    sound_online = [];
    Fs = [];
    filename = [];

end