%% Viterbi Decoder implementation 
% Encoder (3,5,7): [1+D^2, 1+D+D^2]
 
%% Paramenter Declaration
close all;clear all;clc;

info_bits = [1,1,1,0,0,0];                 % pattern to be encoded
bl= length(info_bits);

%% Encoding Part
code_bit0=conv([1 1 1] , info_bits);    %1st Code Bit
code_bit1=conv([1 0 1] , info_bits);    %2nd Code Bit

code_bit0(code_bit0 == 2)=0;            % mod 2
code_bit0(code_bit0 == 3)=1;
code_bit1(code_bit1 == 2)=0;
code_bit1(code_bit1 == 3)=1;

% Modulating Code Bits (or not, do it here)
mod_code_bit0=code_bit0(1:bl);   
mod_code_bit1=code_bit1(1:bl);

%%
% add bit error
disp('added bit error')
e0= 1;
e1= 4;
%  mod_code_bit0(e0)= ~mod_code_bit0(e0);
%  mod_code_bit1(e1)= ~mod_code_bit1(e1);
  

u= [];
for i=1:bl
    u= [u mod_code_bit0(i) mod_code_bit1(i)];
end
fprintf('Encoding completed...\n');

%% ==========================================================================================
%% Decoding Part
% based on K=3, and polynomials [1+D^2, 1+D+D^2]
%
% state transition table    state output table    #### double check table & order of polynomials
% state  next:0   next:1    next:0     next:1
% 00      00       10         00         11
% 01      00       10         11         00
% 10      01       11         10         01
% 11      01       11         01         10


N= 2*bl+2;      % # of state transitions to calculate
M = 1;          % if adding noise iterate M times
state = 0;      % initialize state

for k=1:M
    % Received codebits  
    % No need to interleave bits then parse into groups of two. Just keep as to encoded strings.
    y0=(mod_code_bit0);   % add noise here if needed
    y1=(mod_code_bit1);   % add noise here if needed 
    
    % start from state 0 and calculate distance to all next states
    
        distance=zeros(4,N+1);   	%For storing minimum distance for reaching each of the 4 states
        metric=zeros(8,N);         	%For storing Metric corresponding to each of the 8 transitions
        distance(1,1)=0;distance(2,1)=Inf;distance(3,1)=Inf;distance(4,1)=Inf;  %Initialization of distances
    
    
     % PM is path metric at [state q, time i]
     % initialize to inf except starting state 0
     PM= inf*ones(4,bl+1);
     PM(1,1)= 0;
     
     for i=2:bl+1
         BM(1,i) = sum(xor([mod_code_bit0(i-1),mod_code_bit1(i-1)],[0,0]));
         BM(2,i) = sum(xor([mod_code_bit0(i-1),mod_code_bit1(i-1)],[1,1]));
         
         BM(3,i) = sum(xor([mod_code_bit0(i-1),mod_code_bit1(i-1)],[1,0]));
         BM(4,i) = sum(xor([mod_code_bit0(i-1),mod_code_bit1(i-1)],[0,1]));
         
         BM(5,i) = sum(xor([mod_code_bit0(i-1),mod_code_bit1(i-1)],[1,1]));
         BM(6,i) = sum(xor([mod_code_bit0(i-1),mod_code_bit1(i-1)],[0,0]));
         
         BM(7,i) = sum(xor([mod_code_bit0(i-1),mod_code_bit1(i-1)],[0,1]));
         BM(8,i) = sum(xor([mod_code_bit0(i-1),mod_code_bit1(i-1)],[1,0]));
         
         PM(1,i) = min([BM(1,i)+ PM(1,i-1), BM(2,i)+ PM(2,i-1)]);
         PM(2,i) = min([BM(3,i)+ PM(3,i-1), BM(4,i)+ PM(4,i-1)]);
         PM(3,i) = min([BM(5,i)+ PM(1,i-1), BM(6,i)+ PM(2,i-1)]);
         PM(4,i) = min([BM(7,i)+ PM(3,i-1), BM(8,i)+ PM(4,i-1)]); 
     end   
end

% prune path to final
% Traverse path backward and find MLE path
[decoded_bit_final,sp] = traverse(PM) ;



display(PM)
display(info_bits)
display(decoded_bit_final)