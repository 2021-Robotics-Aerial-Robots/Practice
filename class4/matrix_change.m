function [Matrix] = matrix_change(v)
    % input v is a 1 x 3 matrix
    % output will be a 3 x 9 matrix
    Matrix = [v 0 0 0 0 0 0 ;
              0 0 0 v 0 0 0 ;
              0 0 0 0 0 0 v ];
end