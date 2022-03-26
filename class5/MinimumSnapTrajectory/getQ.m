function Q = getQ(n_seg, n_order, ts)
    Q = [];
    for k = 1:n_seg
        Q_k = [];
        T = ts(k);

        %############################################################
        %           Checkpoint1 : Finish the Q matrix
        % Reminder
        % parameters: Sigma7 Sigma6 Sigma5 Sigma4 Sigma3 Sigma2 Sigma1 Sigma0
        % You cannot directly copy the class slide!

        Q_k = [0];



        %############################################################
        
        Q = blkdiag(Q, Q_k);
    end
end