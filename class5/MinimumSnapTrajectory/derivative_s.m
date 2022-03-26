function temp_v = derivative_s(v, order)

    temp_v = zeros((length(v)-1),1);
    
    for i = 1:1:order
        
        temp_v(i) = ((order+1)-i)*v(i);
    
    end

end