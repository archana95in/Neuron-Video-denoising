%% Initialize
clear;
clc;
close all;
addpath('Code Library'); %import functions

%% Start Timer
tic

%% Declare Constants
NUM_FRAMES = 500;
WIDTH = 512;
HEIGHT = 512;
THRESHOLD = 80;
filename_original = 'Calcium500frames.avi';

%% Read in Video and Display Histogram
fprintf(strcat("Reading ", filename_original, "..."));
original_video = readAVIFile(filename_original, 500, HEIGHT, WIDTH);
clc;
figure;
[~, ~] = histVideo(original_video,0,10^7,'linear');
title("Histogram of Original Video");


%% Define Modified Versions of Original Video
prefiltered_video = uint8(zeros(NUM_FRAMES, HEIGHT, WIDTH));
middle_filtered_video = uint8(zeros(NUM_FRAMES, HEIGHT, WIDTH));
final_filtered_video = uint8(zeros(NUM_FRAMES, HEIGHT, WIDTH));
difference_video = uint8(zeros(NUM_FRAMES, HEIGHT, WIDTH));
%% Process Video
for frame = 1:NUM_FRAMES
    h = fspecial("disk", 2);
    preFilteredFrame = imfilter(getFrame(original_video, frame), h);
    [filteredFrame, groupNumberMatrix, numGroups] = denoiseFrameClustering(preFilteredFrame, THRESHOLD);
    middle_filtered_video(frame,:,:) = filteredFrame;
    prefiltered_video(frame,:,:) = preFilteredFrame;
    fprintf("Filtering Video (Part 1 of 2): %d%% done\n", uint8(frame/NUM_FRAMES * 100));
end
clc; %clear terminal


countMatrix = num_firings(middle_filtered_video);

figure;
imshow(countMatrix, []);
title("Count Matrix");

countMatrix_inverted = uint8(ones(HEIGHT, WIDTH));
countMatrix_inverted = countMatrix_inverted .* 255;
countMatrix_inverted = countMatrix_inverted - countMatrix;
figure;
imshow(countMatrix_inverted, []);
title("Count Matrix (inverted)");



%% Extract Denoised Neurons in Grayscale
for frame = 1:NUM_FRAMES
    fprintf("Filtering Video (Part 2 of 2): %d%% done\n", uint8(frame/NUM_FRAMES * 100));
    for row = 1:HEIGHT
        for col = 1:WIDTH
            if middle_filtered_video(frame, row, col) == 255
                final_filtered_video(frame, row, col) = prefiltered_video(frame, row, col);
            end
            difference_video(frame, row, col) = ...
                    original_video(frame, row, col) - final_filtered_video(frame, row, col);
        end
    end
end
clc; %clear terminal

%% Write Processed Videos to .avi Files
fprintf("Writing Videos to files...");

%write filtered video to .avi file
writeGrayscaleVideo(final_filtered_video, 'filtered.avi', 15);

%write difference video to .avi file
writeGrayscaleVideo(difference_video, 'difference.avi', 15);

%write combined video to .avi file

videos = cat(4, original_video(1:NUM_FRAMES,:,:), prefiltered_video, ...
    middle_filtered_video, final_filtered_video, difference_video);
writeMultipleGrayscaleVideos(videos, 'combined.avi', 15);

clc;

%% Display Histogram of Filtered Video
figure;
[~, ~] = histVideo(final_filtered_video,0,10^7,'log');
title("Histogram of Filtered Video");

%% Display Histogram of Difference Video
figure;
[mean, std_dev] = histVideo(difference_video,0,10^7,'linear');
title("Histogram of Difference Video");

%% Ratio of F/F0
figure;
spikeHist(final_filtered_video);
title("Histogram of Ratio Video");
xlabel("DeltaF/F0");
ylabel("Frequency");

%% Get total number of firing events
totalNumFirings = getTotalCount(countMatrix);
fprintf("Total firing events detected:\t%i\n", totalNumFirings);

%% Stop Timer
toc