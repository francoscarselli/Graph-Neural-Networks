%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function linearModelInitialize
% Initialization function for the linear model

% This function initializes transition, forcing and output neural networks
% The parameters involved are automatically computed on the base
% of the system and the trainset parameters: do not manually edit
global dynamicSystem dataSet

dynamicSystem.config.outNet.nInputs=dynamicSystem.config.nStates+dataSet.config.nodeLabelsDim;
dynamicSystem.config.outNet.nOuts=dynamicSystem.config.nOuts;
[dynamicSystem.parameters.outNet,dynamicSystem.config.outNet]=initializeNet(dynamicSystem.config.outNet);

dynamicSystem.config.transitionNet.nInputs=dataSet.config.nodeLabelsDim;
dynamicSystem.config.transitionNet.nOuts=dynamicSystem.config.nStates^2;
[dynamicSystem.parameters.transitionNet,dynamicSystem.config.transitionNet]=initializeNet(dynamicSystem.config.transitionNet);

dynamicSystem.config.forcingNet.nInputs=dataSet.config.nodeLabelsDim;
dynamicSystem.config.forcingNet.nOuts=dynamicSystem.config.nStates;
[dynamicSystem.parameters.forcingNet,dynamicSystem.config.forcingNet]=initializeNet(dynamicSystem.config.forcingNet);
