%% Define Write Grayscale Video Function
% Inputs:
%   video_array: an array of grayscale images(intensities: [0-255])
%   filename: name of file(should end in ".avi")
%   frame_rate: desired frame rate (in frames per second)


function writeGrayscaleVideo(video_array, filename, frame_rate)
    v = VideoWriter(filename, 'Grayscale AVI');
    v.FrameRate = frame_rate; %match frameRate of original video
    open(v);
    
    [num_frames,~,~] = size(video_array);
    
    for i = 1:num_frames
        writeVideo(v, mat2gray(getFrame(video_array, i)));
        fprintf("Rendered Frame: %i of %s\t%d%% complete\n", i, filename, uint8((i/num_frames) * 100));
    end
    
    clc; %clear terminal
    
    %close video
    close(v);
end