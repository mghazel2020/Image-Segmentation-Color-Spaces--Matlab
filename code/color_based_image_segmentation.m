function [status] = color_based_image_segmentation()
%==========================================================================
% Project: Color-Based Image Segmentation
%==========================================================================
% File: color_based_image_segmentation.m
% Author: Mohsen Ghazel (mghazel2020)
% Date: Mar 12, 2021 
%==========================================================================
% Specifications: 
%==========================================================================
% - This is the driver program, which calls various functionalities and
%   utilities to implment color-based image segmentation
%==========================================================================
% Input:
%==========================================================================
% - None
%==========================================================================
% Output:
%==========================================================================
%  - status = 1 for success and -1 for failure
%==========================================================================
% Execution: 
%
% >> [status] = color_based_image_segmentation()
%
%==========================================================================
% History
%==========================================================================
% Date                      Changes                        Author
%==========================================================================
% Mar 12, 2021              Initial definition             mghazel2020
%==========================================================================
% MIT License:
%==========================================================================
% Copyright (c) 2018-2020 mghazel2020
%==========================================================================
% clear the screen
clc;
% close all open figures
close('all');
% suppress any warnings
warning('off');
% the execution status
status = 0;
%--------------------------------------------------------------------------
% display a message indicating the start of the execution
%--------------------------------------------------------------------------
fprintf(1,'===============================================================\n');
fprintf(1,'Color-Based Image Segmentation:\n');
fprintf(1,'===============================================================\n');
fprintf(1,'Author: mghazel2020\n');
fprintf(1,'===============================================================\n');
fprintf(1,'Execution date and time: %s\n', datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM'));
fprintf(1,'===============================================================\n');

%--------------------------------------------------------------------------
% Add the path to the subaxis
%--------------------------------------------------------------------------
%  - This is an open source MATLAB library used for subplots
%--------------------------------------------------------------------------
addpath('.\subaxis');

%==========================================================================
% Start of execution
%==========================================================================
% - Keep track of the start of execution in order to compute the total
%   execution time of the program
%--------------------------------------------------------------------------
tic;
    
%==========================================================================
% Set the input folder 
%==========================================================================
% input data folder
input_data_folder = '..\data\';
% get the list of images in the input folder
files_list = dir([input_data_folder '*.jpg']);
% the number of imnput images
num_input_images = length(files_list);
% display a message 
fprintf(1, 'There are % d input images in the input folder: %s\n', num_input_images,  input_data_folder )

%==========================================================================
% Set the output folder 
%==========================================================================
% output data folder
output_data_folder = '..\results\';

%==========================================================================
% Apply Color-Based Segmentation Using K-Means Clustering 
% - Applied on each product facing assocaied with a shelf
%==========================================================================
% the color-space
%--------------------------------------------------------------------------
color_spaces = ['HSV'; 'LAB'; 'RGB'];
% the number of color-spaces
num_color_spaces = size(color_spaces, 1);

%--------------------------------------------------------------------------
% number of classes
%--------------------------------------------------------------------------
k_means_list = [7];
% the numbe rof k-means
num_k_means = length(k_means_list);
%--------------------------------------------------------------------------
% Iterate over the input images
%--------------------------------------------------------------------------
for image_counter = 1: num_input_images
    %----------------------------------------------------------------------
    % display a message
    %----------------------------------------------------------------------
    fprintf(1,'============================================================\n');
    fprintf(1,'Processing image #: %d of #: %d:\n',  image_counter, num_input_images);
    fprintf(1,'============================================================\n');
    % input image
    input_img_fname = files_list(image_counter).name;
    % get the input image file
    input_img = imread([input_data_folder input_img_fname]);
    %----------------------------------------------------------------------
    % Iterate over the color-spaces
    %----------------------------------------------------------------------
    for color_space = 1: num_color_spaces
        % get the color-space
        color_space = strtrim(color_spaces(color_space, :));
        %------------------------------------------------------------------
        % Iterate over the K-means
        %------------------------------------------------------------------
        for k_means = 1: num_k_means
            % get the k-means
            k_means = k_means_list(k_means);
            %--------------------------------------------------------------
            % display a message
            %--------------------------------------------------------------
            fprintf(1,'----------------------------------------------------\n');
            fprintf(1,'Color-Segmentation paramaters:\n');
            fprintf(1,'----------------------------------------------------\n');
            fprintf(1,'Color-space = %s\n',  color_space);
            fprintf(1,'K-means = %d\n',  k_means);
            fprintf(1,'----------------------------------------------------\n');
            %--------------------------------------------------------------
            % create output sub-folder 
            %--------------------------------------------------------------
            sub_folder = ['image-' sprintf('%03d', image_counter) '--color-space-' color_space '--k-means-' num2str(k_means)];
            % product-facing-segmentations sub-folder
            output_subfolder = [output_data_folder  sub_folder '\'];
            % create the output sub-folder if it does not exist
            if (exist(output_subfolder,'dir') ~= 7 )
                % create the subfolder
                mkdir(output_subfolder);
            end
            %--------------------------------------------------------------
            % call the color-based segmentation functionality
            %--------------------------------------------------------------
            [status] = apply_color_based_segmentation_using_k_means( input_img, k_means, color_space, output_subfolder );
            % check the execution status
            if ( status == 1 )
                fprintf(1,'apply_color_based_segmentation_using_k_means(...) execution completed successfully!\n')
            else
                fprintf(1,'apply_color_based_segmentation_using_k_means(...) execution failed!\n')
                % set status to failure
                status = -1;
                % return
                return;
            end
        end
    end
end      
% display a final message displaying the execution time of the program.
fprintf(1,'================================================================\n');
fprintf(1,'Program execution completed successfully!\n');
fprintf(1,'Execution time = %s\n', format_time(toc));
fprintf(1,'================================================================\n');
%--------------------------------------------------------------------------
% close all files and figures
%--------------------------------------------------------------------------
% close all other files fids
fclose('all');
% clar all variables
clear all;
% close all figures
% close('all');
%--------------------------------------------------------------------------
% status to success
status = 1;

% return
return;

end

