pub fn inSlice(comptime T: type, haystack: []const T, needle: T) bool {
    for (haystack) |thing| {
        if (thing == needle) {
            return true;
        }
    }
    return false;
}

pub fn orSlice(arr: []const bool) bool {
    for (arr) |res| {
        if (res) return true;
    }
    return false;
}
