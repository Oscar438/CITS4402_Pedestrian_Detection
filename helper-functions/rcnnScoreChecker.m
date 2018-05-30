function probability = rcnnScoreChecker(image,varargin)
%FAST_RCNN_DEMO  Demonstrates Fast-RCNN
%
% Copyright (C) 2016 Abhishek Dutta and Hakan Bilen.
% All rights reserved.
% https://github.com/vlfeat/matconvnet/blob/master/examples/fast_rcnn/fast_rcnn_demo.m
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

% Modified by: Oscar Howse 21116226
% 

%run('CITS4402\NewConvNet\matconvnet-1.0-beta25\matlab\vl_setupnn.m') ;
tic
opts.modelPath = '' ;
opts.classes = {'person'} ;
opts.gpu = [] ;
opts.confThreshold = 0.5 ;
opts.nmsThreshold = 0.3 ;
opts = vl_argparse(opts, varargin) ;

% Load the fast-rcnn-vgg16-pascal07-dagnn network and put it in test mode.
net = load('fast-rcnn-vgg16-pascal07-dagnn.mat') ;
net = dagnn.DagNN.loadobj(net);
net.mode = 'test' ;

% Mark class and bounding box predictions as `precious` so they are
% not optimized away during evaluation.
net.vars(net.getVarIndex('cls_prob')).precious = 1 ;

% Load a test image and convert to grayscale if image is RGB.
if size(image,3) > 1
    im = rgb2gray(image);
    im = single(im) ;
else 
    im = single(image) ;
end
% Load boxes
boxes = load('000004_boxes.mat') ;
boxes = single(boxes.boxes') + 1 ;

% Resize images and boxes to a size compatible with the network.
imageSize = size(im) ;
fullImageSize = net.meta.normalization.imageSize(1) ...
    / net.meta.normalization.cropSize ;
scale = max(fullImageSize ./ imageSize(1:2)) ;
im = imresize(im, scale, ...
              net.meta.normalization.interpolation, ...
              'antialiasing', false) ;
%boxes = [ones(1,2888)*size(image,1);ones(1,2888)*size(image,2)...
%    ;ones(1,2888)*size(image,1)/2;ones(1,2888)*size(image,2)/2];
%boxes = [size(image,1);size(image,2);size(image,1)/2;size(image,2)/2];
          
boxes = bsxfun(@times, boxes - 1, scale) + 1 ;

% Remove the average color from the input image.
imNorm = bsxfun(@minus, im, net.meta.normalization.averageImage) ;

% Convert boxes into ROIs by prepending the image index. There is only
% one image in this batch.
rois = [ones(1,size(boxes,2)) ; boxes] ;

net.conserveMemory = false ;
net.eval({'data', imNorm, 'rois', rois});

% Extract class probabilities
probs = squeeze(gather(net.vars(net.getVarIndex('cls_prob')).value)) ;
c = 16; %Class ID for class 'person'
probability = max(probs(c,:));
FastRCNNTime = sum([net.layers(1:38).forwardTime])
toc