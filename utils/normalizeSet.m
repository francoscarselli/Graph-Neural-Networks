%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function normalizeSet
    
    global dataSet

    
    if (isfield(dataSet, 'trainSet'))
        Mn=max(dataSet.trainSet.nodeLabels');
        mn=min(dataSet.trainSet.nodeLabels');
        Mn=Mn-mn;
        Ml=max(dataSet.trainSet.edgeLabels');
        ml=min(dataSet.trainSet.edgeLabels');
        Ml=Ml-ml;
        dataSet.trainSet.nodeLabels=normalize_(dataSet.trainSet.nodeLabels,Mn,mn);
        dataSet.trainSet.edgeLabels=normalize_(dataSet.trainSet.edgeLabels,Ml,ml);
    else
        disp('ERROR: trainSet not found!!!');
        return
    end
    
    if (isfield(dataSet, 'validationSet'))
        dataSet.validationSet.nodeLabels=normalize_(dataSet.validationSet.nodeLabels,Mn,mn);
        dataSet.validationSet.edgeLabels=normalize_(dataSet.validationSet.edgeLabels,Ml,ml);
    end
    if (isfield(dataSet, 'testSet'))
        dataSet.testSet.nodeLabels=normalize_(dataSet.testSet.nodeLabels,Mn,mn);
        dataSet.testSet.edgeLabels=normalize_(dataSet.testSet.edgeLabels,Ml,ml);
    end
    
    
end

function [R]=normalize_(F,M,m)
    features=F';
    for i=1:size(features,2)
        features(:,i) = (features(:,i)-m(i))/M(i);
    end
    R=features';
end