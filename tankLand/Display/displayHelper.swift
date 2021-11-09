//fit String type
func fit(_ s: String, _ size: Int, right: Bool = true) -> String {
    var result = ""
    let sSize = s.count
    if sSize == size {return s}
    var count = 0
    if size < sSize {
        for c in s {
            if count < size {result.append(c)}
            count += 1
        }
        return result
    }
    result = s
    var addon = ""
    let num = size - sSize
    for _ in 0..<num {addon.append(" ")}
    if right {return  result + addon}
    return addon + result
}

//fit Int type
func fitI(_ i: Int, _ size: Int, right: Bool = false) -> String{
    let iAsString = "\(i)"
    let newLength = iAsString.count
    return fit(iAsString, newLength > size ? newLength : size , right: right)
}
 
