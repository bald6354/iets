%University of Dayton
%Inceptive Event Time Surfaces - ICIAR 2019
%29AUG2019

%Run from 'code' directory

clear, clc


%% Data location
mainPath = ['..' filesep 'NCARS' filesep];


%% Process Train Data
multiTriggerWindow = 12000;
specDir = [num2str(multiTriggerWindow) '_' datestr(now,'yyyymmddHHMMSS')]

for trainTest = {'train' 'test'}
    
    for carsBackground = {'cars' 'background'}
        
        %Find all the NCARS .dat files
        files = dir([mainPath trainTest{1} filesep carsBackground{1} filesep '*.dat']);
        
        %Process each .dat file into an image
        for loop = 1:numel(files)
            
            %Load file
            pts = load_atis_data([files(loop).folder filesep files(loop).name]);
            
            %Find inceptive events
            ie = findInceptiveEvents(pts, multiTriggerWindow);
            
            %Generate 3 color image
            I = pts2image(pts, ie);
            
            %Calculate output time-surface directory
            files(loop).folder = strrep(files(loop).folder,'NCARS',['time_surfaces' filesep specDir]);
            files(loop).name = strrep(files(loop).name,'.dat','.png');
            if loop == 1 && ~exist(files(loop).folder,'dir')
                mkdir(files(loop).folder)
            end
            
            %Write out time-surface image
            imwrite(I,[files(loop).folder filesep files(loop).name])
            
        end
    end
end


%% Create validation dataset (random subset of test to increase speed during training)
subsetSize = 120;

%Cars
mkdir(['..' filesep 'time_surfaces' filesep specDir filesep 'val' filesep 'cars'])
files = dir(['..' filesep 'time_surfaces' filesep specDir filesep 'test' filesep 'cars' filesep '*.png']);
subset = randperm(numel(files),subsetSize);
for loop = 1:numel(subset)
    copyfile([files(subset(loop)).folder filesep files(subset(loop)).name], ...
        [strrep(files(subset(loop)).folder,'test','val') filesep files(subset(loop)).name])
end

%not cars
mkdir(['..' filesep 'time_surfaces' filesep specDir filesep 'val' filesep 'background'])
files = dir(['..' filesep 'time_surfaces' filesep specDir filesep 'test' filesep 'background' filesep '*.png']);
subset = randperm(numel(files),subsetSize);
for loop = 1:numel(subset)
    copyfile([files(subset(loop)).folder filesep files(subset(loop)).name], ...
        [strrep(files(subset(loop)).folder,'test','val') filesep files(subset(loop)).name])
end