function [Aeq beq]= getAbeq(n_seg, n_order, waypoints, ts, start_cond, end_cond)
    
    % the number of all polynomial coefficients
    n_all_poly = n_seg*(n_order+1);

    %% start point constraint
    Aeq_start = zeros(4, n_all_poly);
    beq_start = zeros(4, 1); 
    Aeq_start(1:1:4, 1:1:n_order+1) = [0, 0, 0, 0, 0, 0, 0, 1;
                                       0, 0, 0, 0, 0, 0, 1, 0;
                                       0, 0, 0, 0, 0, 2, 0, 0;
                                       0, 0, 0, 0, 6, 0, 0, 0];
    beq_start = start_cond';% p,v,a,j

    %% end point constraint
    Aeq_end = zeros(4, n_all_poly);
    beq_end = zeros(4, 1);
    
    T = ts(size(ts,1));
    %#####################################################
         % Implement your code here - Checkpoint 2
         % define the end point constraint, should be a matrix of T
    %#####################################################
    %Aeq_end(1:1:4, n_all_poly-n_order:1:n_all_poly) = ...;
    beq_end = end_cond';% p,v,a,j
    %% position constraint in all middle waypoints

    Aeq_wp = zeros(n_seg-1, n_all_poly);
    beq_wp = zeros(n_seg-1, 1);

    for midwp_index = 1:n_seg-1
        index = 1 + 8 * (midwp_index - 1);
        T = ts(midwp_index);
        %#####################################################
             % Implement your code here - Checkpoint 2
             % define the middle way point constraint, should be a matrix of T
        %#####################################################
        %Aeq_wp(midwp_index,index:index+7) = [];
    end

    beq_wp = waypoints(2:n_seg,1);
    %% position continuity constraint between each 2 segments

    Aeq_con_p = zeros(n_seg-1, n_all_poly);
    beq_con_p = zeros(n_seg-1, 1);
    for con_p_index = 1:n_seg-1
        index = 1 + 8 * (con_p_index - 1);
        T = ts(con_p_index);
        Aeq_con_p(con_p_index,index:index+7) = [T^7, T^6, T^5, T^4, T^3, T^2, T, 1];% the end of previous segment
        Aeq_con_p(con_p_index,index+8:index+8+7) = [0, 0, 0, 0, 0, 0, 0, -1];% the begin of next segment
    end
    % beq_con_p is a zero vector

    
    %% velocity continuity constraint between each 2 segments
    Aeq_con_v = zeros(n_seg-1, n_all_poly);
    beq_con_v = zeros(n_seg-1, 1);
    for con_v_index = 1:n_seg-1
        index = 1 + 8 * (con_v_index - 1);
        T = ts(con_v_index);
        %#####################################################
             % Implement your code here - Checkpoint 3
             % define the velocity continuity constraint
        %#####################################################

        %Aeq_con_v(con_v_index,index:index+7) = [];
        %Aeq_con_v(con_v_index,index+8:index+8+7) = [];

    end
    % beq_con_v is a zero vector
    
    %% acceleration continuity constraint between each 2 segments
    Aeq_con_a = zeros(n_seg-1, n_all_poly);
    beq_con_a = zeros(n_seg-1, 1);
    for con_a_index = 1:n_seg-1
        index = 1 + 8 * (con_a_index - 1);
        T = ts(con_a_index);
        %#####################################################
             % Implement your code here - Checkpoint 3
             % define the acceleration continuity constraint
        %#####################################################

        %Aeq_con_a(con_a_index,index:index+7) = [];
        %Aeq_con_a(con_a_index,index+8:index+8+7) = [];
    end
    % beq_con_a is a zero vector
    
    %% jerk continuity constraint between each 2 segments
    Aeq_con_j = zeros(n_seg-1, n_all_poly);
    beq_con_j = zeros(n_seg-1, 1);
    for con_j_index = 1:n_seg-1
        index = 1 + 8 * (con_j_index - 1);
        T = ts(con_j_index);
        %#####################################################
             % Implement your code here - Checkpoint 3
             % define the jerk continuity constraint
        %#####################################################
        %Aeq_con_j(con_j_index,index:index+7) = [];
        %Aeq_con_j(con_j_index,index+8:index+8+7) = [];
    end
    % beq_con_j is a zero vector
    
    %% combine all components to form Aeq and beq   
    Aeq_con = [Aeq_con_p; Aeq_con_v; Aeq_con_a; Aeq_con_j];
    beq_con = [beq_con_p; beq_con_v; beq_con_a; beq_con_j];
    Aeq = [Aeq_start; Aeq_end; Aeq_wp; Aeq_con];
    beq = [beq_start; beq_end; beq_wp; beq_con];
end