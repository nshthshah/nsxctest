import Foundation

/**
 Returns all subclasses of the given type. For example:
 
 allSubClassesOf(UIView) { subclasses:[UIView] in
 subclasses.forEach { NSLog(@0) }
 }
 
 would list all the known current subclasses of `UIView`
 
 - parameter baseClass: The base type to match against
 - returns: An array of T, where T is a subclass of `baseClass`
 */
public func allSubclassesOf<T>(_ baseClass: T) -> [T] {
    var matches: [T] = []

    for currentClass in allClasses() {

        guard class_getRootSuperclass(currentClass) == NSObject.self else {
            continue
        }

        if let cls = currentClass as? T {
            matches.append(cls)
        }
    }

    return matches
}

private func class_getRootSuperclass(_ type: AnyObject.Type) -> AnyObject.Type {
    guard let superclass = class_getSuperclass(type) else { return type }

    return class_getRootSuperclass(superclass)
}

private func allClasses() -> [AnyClass] {
    // Get an approximate amount of classes we are going to need space for.
    // Double it, just to make sure if it returns more we can still accomodate them all
    let expectedClassCount = objc_getClassList(nil, 0) * 2

    let allClasses = UnsafeMutablePointer<AnyClass>.allocate(capacity: Int(expectedClassCount))
    let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)  // Huh? We should have gotten this for free.
    let actualClassCount = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

    // Take care of the stunningly rare situation where we get more classes back than we have allocated,
    // remembering that we have allocated more than we were told to, to take case of the unexpected case
    // where we recieve more classes than we were told we were going to three lines previously. #paranoid #safe
    let count = min(actualClassCount, expectedClassCount)

    var classes = [AnyClass]()
    for index in 0 ..< count {
        let currentClass: AnyClass = allClasses[Int(index)]
        classes.append(currentClass)
    }

    allClasses.deallocate()

    return classes
}

public func getMethodNamesForClass(cls: AnyClass) -> [Method] {
    var methodCount: UInt32 = 0
    var methods = [Method]()
    let methodList = class_copyMethodList(cls, &methodCount)
    if let methodList = methodList, methodCount > 0 {
        enumerateCArray(array: methodList, count: methodCount) { _, method in
            methods.append(method)
        }
        free(methodList)
    }
    return methods
}

public func enumerateCArray<T>(array: UnsafePointer<T>, count: UInt32, from: (UInt32, T) -> Void) {
    var ptr = array
    for index in 0..<count {
        from(index, ptr.pointee)
        ptr = ptr.successor()
    }
}

public func methodName(method: Method) -> String? {
    let sel = method_getName(method)
    let nameCString = sel_getName(sel)
    return String(cString: nameCString)
}

public func getMethodNamesForClassNamed(classname: String) -> [Method] {
    let maybeClass: AnyClass? = NSClassFromString(classname)
    if let cls: AnyClass = maybeClass {
        return getMethodNamesForClass(cls: cls)
    } else {
        NSLogger.error(message: "\(classname): no such class")
    }
    return []
}
