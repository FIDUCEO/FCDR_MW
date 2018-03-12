
% unify flags
% compile a new flag on the constraint that it is one wherever ANY of the
% input flags has one, and zero, where ALL are zero.

function unifiedflags = unify_qualflags(flags)
flagsum=zeros(size(flags{1}));
multiply_by=1/length(flags);

    for numberflag=1:length(flags)
    flagsum=flagsum+double(flags{numberflag}); %add flags
    end
    
 unifiedflags=uint32(multiply_by*flagsum); % divide by "number of used flags", take uint32: will lead to ones, where at least one of the flag is one, and will give zero where both are zero

end



