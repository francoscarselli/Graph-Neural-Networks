%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function [n,r]=subgraphs(A,T,AS,TS)
tsdim=size(TS,2);
gstop=0;
n=zeros(size(A,1),1);
for j=1:tsdim
    pl=find(ismember(T',TS(:,j)','rows'));
    dims(j)=size(pl,1);
    if (dims(j)==0),
        gstop=1;
        break;
    end
    l(j,1:dims(j))=pl';
end

r=0;
ind=ones(tsdim,1);
v=l(:,1);
while ~gstop
    if (A(v,v))==AS
        r=r+1;
        n(v)=1;
    end

    i=tsdim;
    stop=0;
    while ~stop
        if (ind(i)+1)<=dims(i)
            ind(i)=ind(i)+1;
            v(i)=l(i,ind(i));
            stop=1;
        else
            if i>1
                ind(i)=1;
                v(i)=l(i,ind(i));
                i=i-1;
            else
                stop=1;
                gstop=1;
            end
        end
    end
end

