module Slideable
    HORIZ_DIRS = [[0,1], [1,0], [-1,0], [0,-1]]
    DIAG_DIRS = [[-1,-1], [1,1], [-1,1], [1,-1]]
    
    #call each element of DIRS corresponding to piece
    #call grow_unblock, passing in (sub[0], sub[1]) for dx, dy 

    #call move_dirs(in same direction) until invalid move?
    #check along the path for collision 
    def moves
        poss_moves = []
        determine_moves.each do |diff|            #array of directions
            poss_moves += grow_unblocked_moves_in_dir(diff[0],diff[1])
        end
        poss_moves
    end
    
    def determine_moves
        return DIAG_DIRS if self.class == Bishop
        return  HORIZ_DIRS if self.class == Rook
        return HORIZ_DIRS + DIAG_DIRS if self.class == Queen
    end

    #target = [self.position[0]+ dx,self.position[1]+ dy]

    #poss_moves << target if self.board.valid_pos?(target) && self.board[target].nil?
    def grow_unblocked_moves_in_dir(dx, dy)
        arr = []
        curr_dx =  dx
        curr_dy = dy
        growing = true
        until growing == false #initial dx, dy    ;   second  dx, dy
            growing = false
            target = [self.position[0] + curr_dx, self.position[1] + curr_dy] # [0,0] + [0,1]  ;  [0,1] + [0,1]  = [0,2]
            if self.board.valid_pos?(target) 
                if self.board[target].nil? 
                    arr << target
                    growing = true
                elsif board[target].color != self.color
                    arr << target
                end
            end
            curr_dx, curr_dy = curr_dx + dx, curr_dy + dy 
        end
        arr
    end
end

module Steppable
    def moves
        poss_moves = [] # [[1,1],[0,1]
        move_dirs.each do |pos| #king starts @ [3,3] ;  pos =[0,1]
            target = [self.position[0]+ pos[0],self.position[1]+ pos[1]]
            if self.board.valid_pos?(target) 
                if self.board[target].nil? || self.board[target].color != self.color
                    poss_moves << target 
                end
            end
        end
        poss_moves
    end    
end