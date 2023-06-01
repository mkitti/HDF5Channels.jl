module HDF5Channels

import HDF5.API: h5a_iterate, hid_t, H5A_info_t, liblock

"""
    h5a_iterate(Channel, loc_id, idx_type, order; kwargs...)
    h5a_iterate(f, Channel, loc_id, idx_type, order; kwargs...)

Create a `Channel{Tuple{hid_t,Ptr{Cchar},Ptr{H5A_info_t}}}` to iterate over the
attributes. If a function `f` or a do block is provided the channel will be
closed after the function or block returns.

# Examples
```julia-repl
julia> HDF5.API.h5a_iterate(Channel, obj, HDF5.API.H5_INDEX_NAME, HDF5.API.H5_ITER_INC) do ch
           for (loc, name, info) in ch
               println(unsafe_string(name))
           end
       end
```
"""
function h5a_iterate(::Type{Channel}, loc_id, idx_type, order, idx=0; kwargs...)
    ch = Channel{Tuple{hid_t,Ptr{Cchar},Ptr{H5A_info_t}}}(0; kwargs...) do ch
        h5a_iterate(loc_id, idx_type, order, idx) do loc, name, info
            # release API lock
            unlock(liblock)
            try
                isopen(ch) || return true
                put!(ch, (loc, name, info))
            finally
                # restore API lock
                lock(liblock)
            end
            return false
        end
    end
    return ch
end
function h5a_iterate(@nospecialize(f::Function), ::Type{Channel}, args...; kwargs...)
    ch = h5a_iterate(Channel, args...; kwargs...)
    try
        return f(ch)
    finally
        close(ch)
    end
end

end
