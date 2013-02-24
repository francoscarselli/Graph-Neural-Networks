%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function test
% test function

% A classification problem and a regression problem need two different testing strategies. 
% The function choices the one needed from dataSet.config.type

global dataSet learning dynamicSystem
if isempty(dataSet)
    err(0,'Cannot find the datasets')
    return
elseif ~isfield(learning,'current')
    err(0,'Cannot find learning data')
    return
end
if ~isfield(dataSet,'testSet')
    err(0, 'Cannot find the testSet')
    return
end
if ~isfield(dataSet.testSet,'neuralModel')
    prepareDataset('testSet');
    optimizeDataset('testSet');
end
    

if strcmp(func2str(dynamicSystem.config.computeErrorFunction),'neuralModelQuadraticComputeError')
    test4uniform;
elseif strcmp(func2str(dynamicSystem.config.computeErrorFunction),'autoassociatorComputeError')
    test4autoassociator;
elseif strcmp(dataSet.config.type,'classification')
    test4classification;
elseif strcmp(dataSet.config.type,'regression')
    test4regression;
end
