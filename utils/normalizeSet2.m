%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function normalizeSet2()

    global dataSet;
    compute('trainSet','nodeLabels');
    compute('trainSet','edgeLabels');
    compute('validationSet','nodeLabels');
    compute('validationSet','edgeLabels');
    compute('testSet','nodeLabels');
    compute('testSet','edgeLabels');
    
end

function compute(set,type)

    global dataSet;
    A=dataSet.(set).(type);
    %disp strcat( set, type, '\n\t Orig size', num2str(size(A))
    M=dataSet.trainSet.mean.(type);
    %disp strcat( '\n\t mean size', num2str(size(M))
    sA=dataSet.trainSet.var.(type);
    %disp strcat( '\n\t sA size', num2str(size(M))
    A0=A-repmat(M, 1, size(A,2)); 
    %disp strcat( '\n\t A0 size', num2str(size(M))
    dataSet.(set).(type) = A0./repmat(sA, 1, size(A,2));
    %disp strcat( '\n\t A0 size', num2str(size(M))
end

