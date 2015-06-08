% Starts from the last time sample and steps backward along the MLE path

% decoded bits are [1,0] if no ambiguity and [-1] if arbitrary

function [decoded_data, sp]=traverse(path_metric)

    [num_states,last] = size(path_metric);
    uncoded_bits = last-1;
    
    sp= inf*path_metric;
    
    decoded_data = zeros(1,uncoded_bits);  % declare & initialize 
    curr_state = find(path_metric(:,last)==min(path_metric(:,last))) 
    
    sp(curr_state,last)= path_metric(curr_state,last);
    
    
    for j=2:(last)
        k = last-j+2;              % index moving last to first
        
        if(curr_state==1)
            if( path_metric(1,k-1) <= path_metric(2,k-1))
                prev_state=1;decoded_bit=0;
            else
                prev_state=2;decoded_bit=1;
            end
        end
    
        if(curr_state==2)
            if( path_metric(3,k-1) <= path_metric(4,k-1))
                prev_state=3;decoded_bit=0;
            else
                prev_state=4;decoded_bit=1;
            end
        end
    
        if(curr_state==3)
            if( path_metric(1,k-1) <= path_metric(2,k-1))
                prev_state=1;decoded_bit=0;
            else
                prev_state=2;decoded_bit=1;
            end
        end
    
        if(curr_state==4)
            if( path_metric(3,k-1) <= path_metric(4,k-1))
                prev_state=3;decoded_bit=0;
            else
                prev_state=4;decoded_bit=1;
            end
        end
        
       sp(prev_state,k-1) = path_metric(prev_state,k-1);
       % disp([curr_state k path_metric(curr_state,k)])
        
        decoded_data(k) = decoded_bit;
        
       % [k prev_state curr_state] 
       
        curr_state = prev_state ;
      
        
        
   
        
        
    end %%%%
    
    decoded_data = fliplr(decoded_data(1:last-1))
    
 